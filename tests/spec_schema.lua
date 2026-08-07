-- tests/spec_schema.lua (The defaults schema and the stat registry agree)
--
-- CONTRIBUTING.md lists three things to touch when adding a stat: STAT_DEFS,
-- the `stats` block in Config.lua, and SP.STAT_ORDER. Miss one and there is no
-- error -- the stat simply never appears, or appears with no settings, or the
-- options page lists a row that renders nothing. This file is that checklist,
-- enforced.

return function(H, SP)
    local DEFAULTS = SP.Config.DEFAULTS

    H.describe("stat registry", function()
        H.it("gives every ordered stat a definition", function()
            for _, name in ipairs(SP.STAT_ORDER) do
                H.ok(SP.STAT_DEFS[name], name .. " is listed in STAT_ORDER but has no STAT_DEFS entry")
            end
        end)

        H.it("gives every ordered stat display defaults", function()
            for _, name in ipairs(SP.STAT_ORDER) do
                H.ok(DEFAULTS.stats[name], name .. " has no entry in Config DEFAULTS.stats")
            end
        end)

        H.it("lists every defined stat in STAT_ORDER", function()
            -- The other direction: a stat with a definition but no place in the
            -- order is invisible in the options window.
            local ordered = {}
            for _, name in ipairs(SP.STAT_ORDER) do ordered[name] = true end
            for name in pairs(SP.STAT_DEFS) do
                H.ok(ordered[name], name .. " has a STAT_DEFS entry but is missing from STAT_ORDER")
            end
        end)

        H.it("gives every stat a name and a getter", function()
            for name, def in pairs(SP.STAT_DEFS) do
                H.eq(type(def.name), "string", name .. " needs a display name")
                H.ok(def.name ~= "", name .. "'s display name is empty")
                H.eq(type(def.get), "function", name .. " needs a get function")
            end
        end)

        H.it("has no duplicates in STAT_ORDER", function()
            local seen = {}
            for _, name in ipairs(SP.STAT_ORDER) do
                H.notOk(seen[name], name .. " appears twice in STAT_ORDER")
                seen[name] = true
            end
        end)

        H.it("returns a usable value from every getter", function()
            -- Against the stub, not the game -- this proves the getter is
            -- wired up and returns the documented shape, not that the number
            -- is right.
            for name, def in pairs(SP.STAT_DEFS) do
                local ok, value = pcall(def.get, "total")
                H.ok(ok, name .. "'s getter raised: " .. tostring(value))
                if ok then
                    H.ok(value ~= nil, name .. "'s getter returned nil")
                end
            end
        end)

        H.it("survives the bonus value source too", function()
            for name, def in pairs(SP.STAT_DEFS) do
                H.noRaise(function() def.get("bonus") end, name .. " with valueSource=bonus")
            end
        end)
    end)

    H.describe("stat display defaults", function()
        H.it("gives every stat a complete config", function()
            for name, cfg in pairs(DEFAULTS.stats) do
                H.eq(type(cfg.color), "table", name .. " needs a colour")
                H.eq(#cfg.color, 4, name .. "'s colour needs four channels")
                H.eq(type(cfg.format), "string", name .. " needs a value format")
                H.eq(type(cfg.decimals), "number", name .. " needs a decimal count")
                H.eq(type(cfg.max), "number", name .. " needs a bar maximum")
            end
        end)

        H.it("keeps every colour channel in range", function()
            for name, cfg in pairs(DEFAULTS.stats) do
                for i, channel in ipairs(cfg.color) do
                    H.ok(type(channel) == "number" and channel >= 0 and channel <= 1,
                        name .. " colour channel " .. i .. " is out of 0..1")
                end
            end
        end)

        H.it("uses a bar maximum a value can actually reach", function()
            for name, cfg in pairs(DEFAULTS.stats) do
                H.ok(cfg.max > 0, name .. " has a non-positive bar maximum")
            end
        end)

        H.it("only uses fill modes the renderer knows", function()
            local VALID = { value = true, max = true, none = true }
            for name, cfg in pairs(DEFAULTS.stats) do
                H.ok(VALID[cfg.fill], name .. " has an unknown fill mode: " .. tostring(cfg.fill))
            end
        end)
    end)

    H.describe("default sections", function()
        H.it("references only real stats", function()
            for _, section in ipairs(DEFAULTS.sections) do
                for _, name in ipairs(section.stats) do
                    H.ok(SP.STAT_DEFS[name],
                        "section '" .. section.id .. "' lists unknown stat: " .. name)
                end
            end
        end)

        H.it("gives every section an id and a title", function()
            local seen = {}
            for _, section in ipairs(DEFAULTS.sections) do
                H.eq(type(section.id), "string")
                H.eq(type(section.title), "string")
                H.notOk(seen[section.id], "duplicate section id: " .. tostring(section.id))
                seen[section.id] = true
            end
        end)

        H.it("places each stat in at most one section", function()
            local home = {}
            for _, section in ipairs(DEFAULTS.sections) do
                for _, name in ipairs(section.stats) do
                    H.notOk(home[name],
                        name .. " is in both '" .. tostring(home[name]) .. "' and '" .. section.id .. "'")
                    home[name] = section.id
                end
            end
        end)

        H.it("has a home for every stat", function()
            -- A stat in no section can be enabled in the options and still
            -- never draw, which reads as a broken setting.
            local placed = {}
            for _, section in ipairs(DEFAULTS.sections) do
                for _, name in ipairs(section.stats) do placed[name] = true end
            end
            for _, name in ipairs(SP.STAT_ORDER) do
                H.ok(placed[name], name .. " belongs to no default section")
            end
        end)
    end)

    H.describe("stat priority table", function()
        H.it("gives every spec four distinct secondaries", function()
            H.ok(next(SP.StatPriority), "the priority table is populated at all")
            for specID, priority in pairs(SP.StatPriority) do
                H.eq(#priority, 4, "spec " .. specID .. " needs all four secondaries")
                local seen = {}
                for _, stat in ipairs(priority) do
                    H.notOk(seen[stat], "spec " .. specID .. " lists " .. stat .. " twice")
                    seen[stat] = true
                    H.ok(SP.STAT_DEFS[stat], "spec " .. specID .. " lists unknown stat " .. stat)
                end
            end
        end)
    end)

    H.describe("footer and title defaults", function()
        H.it("uses format strings the footer can actually apply", function()
            local footer = DEFAULTS.footer
            for _, key in ipairs({ "fpsFormat", "homeFormat", "worldFormat",
                "memoryFormat", "durabilityFormat" }) do
                H.noRaise(function() return string.format(footer[key], 60) end,
                    "footer." .. key .. " must format a number")
            end
        end)

        H.it("orders its quality thresholds correctly", function()
            local footer = DEFAULTS.footer
            H.ok(footer.fpsGood > footer.fpsBad, "higher fps is better")
            H.ok(footer.msGood < footer.msBad, "lower latency is better")
            H.ok(footer.durabilityGood > footer.durabilityBad, "higher durability is better")
        end)
    end)
end
