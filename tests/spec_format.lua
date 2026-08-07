-- tests/spec_format.lua (The $token value templates)
--
-- buildFormat is the secret-value workaround: it compiles a user-authored
-- template into a printf format string, touching only the plain text, so the
-- protected number can be passed to SetFormattedText as an argument instead of
-- being substituted into a string. Two properties matter more than any single
-- output, and both are checked below:
--
--   1. The returned format survives string.format with the arguments the
--      returned order says it wants -- for EVERY template, including nonsense.
--   2. No live value is ever interpolated by gsub.

return function(H, SP)
    local buildFormat = SP.BuildFormat
    local cfg2 = { decimals = 2, max = 100 }

    -- Mirrors what StatPanel's render path does with the pair.
    local function render(template, cfg, label, value, rating, extra, statName)
        local fmt, order = buildFormat(template, cfg or cfg2, label or "Mastery", extra, statName)
        local args = {}
        for i, which in ipairs(order) do
            args[i] = (which == "value") and (value or 10.65) or (rating or 285)
        end
        return string.format(fmt, unpack(args, 1, #order)), fmt, order
    end

    H.describe("tokens", function()
        H.it("renders the documented example", function()
            -- README: "$rating - $value%" gives "285 - 10.65%".
            H.eq((render("$rating - $value%")), "285 - 10.65%")
        end)

        H.it("honours the decimal setting", function()
            H.eq((render("$value", { decimals = 0, max = 100 })), "11")
            H.eq((render("$value", { decimals = 4, max = 100 })), "10.6500")
        end)

        H.it("clamps decimals to a sane range", function()
            -- "%.-3f" and "%.99f" are both string.format errors, and this value
            -- comes from a saved profile that could say anything.
            H.noRaise(function() render("$value", { decimals = -3, max = 100 }) end)
            H.noRaise(function() render("$value", { decimals = 99, max = 100 }) end)
            H.noRaise(function() render("$value", { decimals = nil, max = 100 }) end)
        end)

        H.it("substitutes $label with the stat name", function()
            H.eq((render("$label: $value%", nil, "Haste")), "Haste: 10.65%")
        end)

        H.it("substitutes $max from the config", function()
            H.eq((render("$value / $max", { decimals = 1, max = 250 })), "10.7 / 250")
        end)

        H.it("substitutes $yards from the extra argument", function()
            H.eq((render("$yards yd/s", nil, nil, nil, nil, 7.5)), "7.5 yd/s")
        end)

        H.it("treats $yards as zero when the value is unusable", function()
            -- The game hands movement speed over as a secret; plainNumber
            -- returns nil and the token must still render something.
            H.eq((render("$yards", nil, nil, nil, nil, nil)), "0.0")
        end)

        H.it("substitutes $per with the rating cost of 1%", function()
            -- The stub reports 1500 rating and a 12.5% bonus: 120 per point.
            H.eq((render("$per", nil, nil, nil, nil, nil, "Crit")), "120")
        end)

        H.it("renders $per as a dash for a stat with no rating behind it", function()
            -- Attack power, health and the primaries have no combat rating, so
            -- there is no cost to report and nothing to invent.
            H.eq((render("$per", nil, nil, nil, nil, nil, "Health")), "-")
            H.eq((render("$per", nil, nil, nil, nil, nil, nil)), "-")
        end)

        H.it("reads $per off the rating bonus, not the displayed value", function()
            -- Crit's displayed total includes a base the rating never paid for.
            -- Dividing by that would understate the cost, and would also make
            -- the answer depend on the total/bonus value-source setting.
            H.eq(SP.RatingPerPercent("Crit"), 1500 / 12.5)
        end)

        H.it("leaves an unknown token alone", function()
            local out = render("$nonsense $value")
            H.ok(out:find("$nonsense", 1, true), "unrecognized tokens stay literal")
        end)

        H.it("reports which live values the format wants, in order", function()
            local _, _, order = render("$rating/$value/$rating")
            H.same(order, { "rating", "value", "rating" })
        end)
    end)

    H.describe("secret safety", function()
        H.it("never bakes a live value into the format string", function()
            -- If $value were interpolated by gsub, the number would appear in
            -- fmt. It must appear only as a specifier for SetFormattedText.
            local _, fmt = render("$value%", { decimals = 2, max = 100 }, nil, 10.65)
            H.notOk(fmt:find("10.65", 1, true),
                "the value must reach SetFormattedText as an argument")
            H.ok(fmt:find("%%%.2f"), "as a %.2f specifier")
        end)

        H.it("emits exactly one specifier per live token", function()
            for _, template in ipairs({ "$value", "$rating", "$value $rating",
                "$value$value$value", "$label $value ($rating)" }) do
                local fmt, order = buildFormat(template, cfg2, "Mastery")
                local _, count = fmt:gsub("%%[%-%+ #0-9%.]*[dfs]", "")
                H.eq(count, #order, "specifier count matches order for: " .. template)
            end
        end)
    end)

    H.describe("percent escaping", function()
        H.it("survives a literal percent next to a token", function()
            H.eq((render("$value%")), "10.65%")
        end)

        H.it("survives a template that is nothing but percents", function()
            H.eq((render("100%%")), "100%%")
        end)

        H.it("does not let $label smuggle in a specifier", function()
            -- Stat labels are renameable free text. "%d" as a label would eat
            -- an argument and shift every later one.
            H.eq((render("$label = $value", nil, "%d%s")), "%d%s = 10.65")
        end)

        H.it("does not let $max or $yards smuggle in a specifier", function()
            H.noRaise(function() render("$max", { decimals = 2, max = 100 }) end)
        end)
    end)

    H.describe("templates users can actually type", function()
        -- Every one of these is formatted once per frame. A raise here is a
        -- raise sixty times a second, which is the failure this guards.
        local TEMPLATES = {
            "", "$value", "%", "%%", "%d", "%s", "100%", "$value%%",
            "$", "$$value", "$value $value $value $value",
            "[$label] $rating -> $value%", "$VALUE", "$Value",
            "%-10.4f", "$value\n$rating", "  $value  ",
            "$peak / $value", "$valuec ($ratingc)", "$per", "$value% ($per)",
        }

        H.it("never raises for any of them", function()
            for _, template in ipairs(TEMPLATES) do
                H.noRaise(function() render(template) end, "template: " .. template)
            end
        end)
    end)

    H.describe("SafeFormat", function()
        local safeFormat = SP.SafeFormat

        H.it("formats a good template", function()
            H.eq(safeFormat("%d  ", "%d  ", 3), "3  ")
        end)

        H.it("falls back when the template has too many specifiers", function()
            H.eq(safeFormat("%d %d", "%d", 3), "3")
        end)

        H.it("falls back when the template has the wrong specifier", function()
            H.eq(safeFormat("%z", "%d", 3), "3")
        end)

        H.it("degrades to the bare value when both templates are bad", function()
            H.eq(safeFormat("%z", "%z", 3), "3")
        end)

        H.it("never raises, whatever the user typed", function()
            for _, bad in ipairs({ "%", "%%%", "%d %s %f", "%1000000d", "" }) do
                H.noRaise(function() safeFormat(bad, "%d", 42) end, "rank format: " .. bad)
            end
        end)
    end)

    H.describe("ToHex", function()
        H.it("renders a colour array", function()
            H.eq(SP.ToHex({ 1, 0, 0, 1 }), "|cffff0000")
            H.eq(SP.ToHex({ 0, 0, 0, 1 }), "|cff000000")
        end)

        H.it("rounds rather than truncating", function()
            H.eq(SP.ToHex({ 0.5, 0.5, 0.5 }), "|cff808080")
        end)

        H.it("returns white for a missing colour", function()
            H.eq(SP.ToHex(nil), "|cffffffff")
            H.eq(SP.ToHex("not a colour"), "|cffffffff")
        end)
    end)

    H.describe("PlainNumber", function()
        H.it("passes ordinary numbers through", function()
            H.eq(SP.PlainNumber(42), 42)
            H.eq(SP.PlainNumber(0), 0)
            H.eq(SP.PlainNumber(-1.5), -1.5)
        end)

        H.it("returns nil for anything not usable in arithmetic", function()
            H.eq(SP.PlainNumber(nil), nil)
            H.eq(SP.PlainNumber({}), nil)
            H.eq(SP.PlainNumber(true), nil)
            H.eq(SP.PlainNumber("not a number"), nil)
            H.eq(SP.PlainNumber(print), nil)
        end)

        H.it("coerces a numeric string, because Lua does", function()
            -- The test is the contract: "usable in arithmetic", not "is a
            -- number". A width stored as "12" by a hand-edited SavedVariables
            -- is usable, and rejecting it would be the surprising behaviour.
            H.eq(SP.PlainNumber("12"), 12)
        end)
    end)
end
