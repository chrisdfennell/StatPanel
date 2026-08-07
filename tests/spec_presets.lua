-- tests/spec_presets.lua (The 22 one-click looks)
--
-- A preset is a sparse table of settings merged over the profile. There is no
-- schema behind it and no error when a key is wrong: a typo'd or renamed key is
-- written into the profile, read by nobody, and the preset just quietly does
-- less than it says. CONTRIBUTING calls this out for options; it is worse for
-- presets, because there are 22 of them and nobody applies all 22 by hand.
--
-- The load-bearing test here is "writes only keys the schema defines".

return function(H, SP)
    local Presets = SP.Presets
    local DEFAULTS = SP.Config.DEFAULTS

    local function freshDB()
        _G.SPAddonDB = {}
        SP.Config:Init()
    end

    -- Walks a sparse preset table against the defaults schema, collecting the
    -- dotted path of anything the schema has no place for.
    local function unknownPaths(settings, schema, prefix, out)
        out = out or {}
        for key, value in pairs(settings) do
            local path = prefix and (prefix .. "." .. tostring(key)) or tostring(key)
            local expected = schema[key]

            if expected == nil then
                out[#out + 1] = path
            elseif type(value) == "table" and type(expected) == "table" then
                -- A colour or any other array of scalars is a leaf: its indices
                -- are positions, not schema keys.
                if #expected == 0 or type(expected[1]) == "table" then
                    unknownPaths(value, expected, path, out)
                end
            end
        end
        return out
    end

    H.describe("the preset list", function()
        H.it("lists every preset in the display order", function()
            local ordered = {}
            for _, name in ipairs(Presets.order) do
                ordered[name] = true
                H.ok(Presets.list[name], "'" .. name .. "' is ordered but not defined")
            end
            for name in pairs(Presets.list) do
                H.ok(ordered[name], "'" .. name .. "' is defined but never shown")
            end
        end)

        H.it("has no duplicates in the order", function()
            local seen = {}
            for _, name in ipairs(Presets.order) do
                H.notOk(seen[name], "'" .. name .. "' is listed twice")
                seen[name] = true
            end
        end)

        H.it("gives every preset a description and settings", function()
            for name, preset in pairs(Presets.list) do
                H.eq(type(preset.desc), "string", name .. " needs a description")
                H.ok(preset.desc ~= "", name .. "'s description is empty")
                H.eq(type(preset.settings), "table", name .. " needs a settings table")
            end
        end)
    end)

    H.describe("preset keys", function()
        H.it("writes only keys the schema defines", function()
            -- This is the check that pays for the file. A key not in DEFAULTS is
            -- read by nothing, so the preset silently does less than it claims.
            for name, preset in pairs(Presets.list) do
                local unknown = unknownPaths(preset.settings, DEFAULTS)
                H.eq(#unknown, 0, name .. " sets unknown keys: " .. table.concat(unknown, ", "))
            end
        end)

        H.it("writes values of the type the schema expects", function()
            local function checkTypes(settings, schema, prefix, name)
                for key, value in pairs(settings) do
                    local expected = schema[key]
                    local path = prefix and (prefix .. "." .. tostring(key)) or tostring(key)
                    if expected ~= nil then
                        if type(expected) == "table" and type(value) == "table" then
                            if #expected == 0 or type(expected[1]) == "table" then
                                checkTypes(value, expected, path, name)
                            end
                        else
                            H.eq(type(value), type(expected),
                                name .. " sets " .. path .. " to the wrong type")
                        end
                    end
                end
            end
            for name, preset in pairs(Presets.list) do
                checkTypes(preset.settings, DEFAULTS, nil, name)
            end
        end)

        H.it("names only real stats in its per-stat overrides", function()
            for name, preset in pairs(Presets.list) do
                for statName in pairs(preset.stats or {}) do
                    H.ok(SP.STAT_DEFS[statName],
                        name .. " overrides unknown stat '" .. statName .. "'")
                end
            end
        end)

        H.it("names only real stats in its sections", function()
            for name, preset in pairs(Presets.list) do
                for _, section in ipairs(preset.sections or {}) do
                    for _, statName in ipairs(section.stats or {}) do
                        H.ok(SP.STAT_DEFS[statName],
                            name .. " puts unknown stat '" .. statName .. "' in a section")
                    end
                end
            end
        end)

        H.it("uses colour arrays of four channels in range", function()
            local function checkColors(settings, schema, prefix, name)
                for key, value in pairs(settings) do
                    local expected = schema[key]
                    local path = prefix and (prefix .. "." .. tostring(key)) or tostring(key)
                    if type(expected) == "table" and type(expected[1]) == "number" then
                        H.eq(#value, 4, name .. "'s " .. path .. " needs four channels")
                        for i, channel in ipairs(value) do
                            H.ok(type(channel) == "number" and channel >= 0 and channel <= 1,
                                name .. "'s " .. path .. " channel " .. i .. " is out of 0..1")
                        end
                    elseif type(expected) == "table" and type(value) == "table" then
                        checkColors(value, expected, path, name)
                    end
                end
            end
            for name, preset in pairs(Presets.list) do
                checkColors(preset.settings, DEFAULTS, nil, name)
            end
        end)

        H.it("picks fonts that every client can draw", function()
            -- A preset naming a Latin-only face renders as boxes on a Korean or
            -- Chinese client. Media:Fetch substitutes at draw time; a preset
            -- should not be relying on that.
            for name, preset in pairs(Presets.list) do
                local face = preset.settings.font and preset.settings.font.face
                if face then
                    H.notOk(face == "Friz Quadrata",
                        name .. " names Friz Quadrata; use 'Game Default' so it "
                        .. "resolves per locale")
                end
            end
        end)
    end)

    H.describe("applying a preset", function()
        H.it("applies every preset without raising", function()
            for _, name in ipairs(Presets.order) do
                freshDB()
                H.noRaise(function() Presets:Apply(name) end, "applying " .. name)
            end
        end)

        H.it("reports failure for an unknown name", function()
            freshDB()
            H.notOk(Presets:Apply("No Such Preset"))
        end)

        H.it("leaves a complete, valid profile behind", function()
            -- A preset that omits a key must leave the previous value, not nil:
            -- the render path indexes these without guards.
            for _, name in ipairs(Presets.order) do
                freshDB()
                Presets:Apply(name)
                H.eq(type(SP.db.panel.width), "number", name .. " left panel.width unusable")
                H.eq(type(SP.db.bars.height), "number", name .. " left bars.height unusable")
                H.eq(type(SP.db.font.face), "string", name .. " left font.face unusable")
                H.eq(#SP.db.panel.bgColor, 4, name .. " left a malformed bgColor")
            end
        end)

        H.it("does not move the panel or change visibility rules", function()
            -- The whole point of a sparse preset: switching looks must not
            -- relocate a panel the user positioned or re-show a hidden one.
            for _, name in ipairs(Presets.order) do
                freshDB()
                SP.db.panel.pos = { point = "TOPLEFT", relPoint = "TOPLEFT", x = 17, y = -23 }
                SP.db.panel.hideInCombat = true
                Presets:Apply(name)
                H.eq(SP.db.panel.pos.x, 17, name .. " moved the panel")
                H.eq(SP.db.panel.hideInCombat, true, name .. " changed a visibility rule")
            end
        end)

        H.it("does not alias a preset's own tables into the profile", function()
            -- A raw assignment would share one colour table between the preset
            -- and every profile using it, so editing one would edit them all.
            freshDB()
            Presets:Apply("Neon")
            local before = SP.db.panel.bgColor[1]
            SP.db.panel.bgColor[1] = 0.987

            freshDB()
            Presets:Apply("Neon")
            H.eq(SP.db.panel.bgColor[1], before,
                "the in-memory preset was mutated by editing a profile")
        end)

        H.it("survives a preset applied twice", function()
            freshDB()
            Presets:Apply("Terminal")
            local width = SP.db.panel.width
            Presets:Apply("Terminal")
            H.eq(SP.db.panel.width, width)
        end)

        H.it("fully replaces the previous look", function()
            -- resetLook() exists so switching from Classic Text back to a bar
            -- preset doesn't leave text-style leftovers behind.
            freshDB()
            Presets:Apply("Classic Text")
            H.eq(SP.db.bars.style, "text")
            Presets:Apply("Modern Bars")
            H.eq(SP.db.bars.style, "bar")
        end)
    end)

    H.describe("the ElvUI presets", function()
        H.it("work with ElvUI absent", function()
            -- The stub provides no ElvUI, which is the case for most users.
            -- The dynamic hook must fall back rather than raise.
            freshDB()
            H.noRaise(function() Presets:Apply("ElvUI") end)
            H.noRaise(function() Presets:Apply("ElvUI Transparent") end)
            H.eq(type(SP.db.font.face), "string")
        end)
    end)
end
