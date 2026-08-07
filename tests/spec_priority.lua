-- tests/spec_priority.lua (Pawn / sim string parsing)
--
-- This function's whole input is text a stranger pasted from a website, so the
-- cases that matter are the malformed ones.

return function(H, SP)
    local function parse(text)
        return SP:ParsePriorityString(text)
    end

    H.describe("weight strings", function()
        H.it("orders by descending weight", function()
            local order = parse("CritRating=1.20, HasteRating=2.40, MasteryRating=1.80, VersatilityRating=0.90")
            H.same(order, { "Haste", "Mastery", "Crit", "Versatility" })
        end)

        H.it("reads a real Pawn scale string", function()
            local order = parse(
                "( Pawn: v1: \"Beast Mastery\": Class=Hunter, Agility=10.00, "
                .. "CritRating=6.44, HasteRating=8.13, MasteryRating=7.02, "
                .. "VersatilityRating=5.51 )")
            H.same(order, { "Haste", "Mastery", "Crit", "Versatility" })
        end)

        H.it("appends stats the string omits, in canonical order", function()
            -- A two-stat string is still a valid answer; the result must stay a
            -- full permutation or the priority line and dropdowns break.
            local order = parse("MasteryRating=3, CritRating=1")
            H.eq(#order, 4, "always four secondaries")
            H.eq(order[1], "Mastery")
            H.eq(order[2], "Crit")
        end)

        H.it("handles negative and zero weights", function()
            local order = parse("CritRating=0, HasteRating=-1.5, MasteryRating=2")
            H.same(order, { "Mastery", "Crit", "Haste", "Versatility" })
        end)

        H.it("ignores primary stats and other keys", function()
            local order = parse("Agility=10, Stamina=4, CritRating=3, HasteRating=9")
            H.eq(order[1], "Haste")
            H.eq(order[2], "Crit")
        end)

        H.it("keeps the first weight when a stat appears twice", function()
            local order = parse("CritRating=9, CritRating=1, HasteRating=5")
            H.eq(order[1], "Crit")
        end)

        H.it("rejects a string with only one readable weight", function()
            local order, err = parse("CritRating=1.2")
            H.eq(order, nil)
            H.ok(err, "explains itself")
        end)

        H.it("rejects a half-typed weight string rather than reading it as an order", function()
            -- The '=' is what makes this the weight branch. Falling through to
            -- the word-list branch would silently return file order.
            local order = parse("CritRating=")
            H.eq(order, nil)
        end)
    end)

    H.describe("plain orders", function()
        H.it("reads a > separated order", function()
            H.same(parse("Mastery > Haste > Crit > Vers"),
                { "Mastery", "Haste", "Crit", "Versatility" })
        end)

        H.it("accepts commas and bare spaces", function()
            H.same(parse("haste, crit, mastery, versatility"),
                { "Haste", "Crit", "Mastery", "Versatility" })
            H.same(parse("vers mastery haste crit"),
                { "Versatility", "Mastery", "Haste", "Crit" })
        end)

        H.it("is case insensitive and tolerates abbreviations", function()
            H.same(parse("MAST > VERS > CRIT > HASTE"),
                { "Mastery", "Versatility", "Crit", "Haste" })
        end)

        H.it("keeps the first mention when a stat repeats", function()
            H.same(parse("Crit > Haste > Crit > Mastery > Vers"),
                { "Crit", "Haste", "Mastery", "Versatility" })
        end)

        H.it("completes a partial order", function()
            local order = parse("Vers > Mastery")
            H.eq(#order, 4)
            H.eq(order[1], "Versatility")
            H.eq(order[2], "Mastery")
        end)

        H.it("accepts the abbreviations the panel itself displays", function()
            -- The compact priority chain renders "Crit > Mast > Vers". Not
            -- accepting its own output back was the original bug here.
            H.same(parse("Crit > Mast > Vers > Haste"),
                { "Crit", "Mastery", "Versatility", "Haste" })
        end)

        H.it("accepts the client's own stat names", function()
            -- The stub reports the English client, where GlobalStrings say
            -- "Critical Strike". A German client registers "Tempo" the same way.
            H.same(parse("Critical Strike > Haste > Mastery > Versatility"),
                { "Crit", "Haste", "Mastery", "Versatility" })
        end)

        H.it("tokenizes without relying on ASCII letters", function()
            -- %a matches no Cyrillic byte, so a locale-name order string used to
            -- parse as zero words. This asserts the splitter, not a translation.
            local order = parse("\208\188\208\176\209\129\209\130 > Haste > Crit > Vers")
            H.eq(#order, 4, "an unrecognized non-ASCII word must not break the rest")
            H.eq(order[1], "Haste")
        end)
    end)

    H.describe("bad input", function()
        H.it("rejects nil, empty and whitespace", function()
            H.eq((parse(nil)), nil)
            H.eq((parse("")), nil)
            H.eq((parse("   \t ")), nil)
            H.eq((parse(12345)), nil)
        end)

        H.it("rejects text with no stats in it", function()
            local order, err = parse("the quick brown fox")
            H.eq(order, nil)
            H.ok(err)
        end)

        H.it("returns a reason with every rejection", function()
            for _, bad in ipairs({ "", "nonsense", "CritRating=1.2" }) do
                local order, err = parse(bad)
                H.eq(order, nil, "rejected: " .. bad)
                H.eq(type(err), "string", "reason given for: " .. bad)
            end
        end)

        H.it("survives regex metacharacters", function()
            H.noRaise(function() parse("%d %s [](){}.-+*?^$") end)
            H.noRaise(function() parse("Crit=1e999, Haste=2") end)
        end)
    end)
end
