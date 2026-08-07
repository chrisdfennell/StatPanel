-- tests/spec_profiles.lua (Profiles, migration, sanitizing, import/export)
--
-- The highest-stakes code in the addon. Everything here runs against the user's
-- saved variables: get it wrong and a person loses a configuration they spent an
-- hour on, with no undo. The v1 migration in particular runs exactly once per
-- database, on data nobody can reproduce afterwards.

return function(H, SP)
    local Config = SP.Config
    local DEFAULTS = Config.DEFAULTS

    -- Each test gets a fresh database. Config reads and writes the SPAddonDB
    -- global exactly as the game's SavedVariables does.
    local function freshDB(seed)
        _G.SPAddonDB = seed or {}
        Config:Init()
        return _G.SPAddonDB
    end

    H.describe("Config:Init", function()
        H.it("creates a Default profile from nothing", function()
            local db = freshDB()
            H.ok(db.profiles.Default, "a Default profile exists")
            H.eq(db.version, 2, "the schema version is stamped")
            H.ok(SP.db, "a profile is active")
        end)

        H.it("points the current character at a profile", function()
            local db = freshDB()
            local key = Config.CharKey()
            H.eq(db.chars[key], "Default")
        end)

        H.it("is idempotent", function()
            local db = freshDB()
            db.profiles.Default.panel.width = 321
            Config:Init()
            H.eq(db.profiles.Default.panel.width, 321,
                "re-running Init must not reset a customized profile")
        end)

        H.it("repoints a character whose profile was deleted", function()
            local db = freshDB()
            db.chars[Config.CharKey()] = "A Profile That Is Gone"
            Config:Init()
            H.eq(db.chars[Config.CharKey()], "Default")
        end)

        H.it("strips runtimeMax, which never belonged in a profile", function()
            local db = freshDB()
            db.profiles.Default.stats.Speed.runtimeMax = 480
            Config:Init()
            H.eq(db.profiles.Default.stats.Speed.runtimeMax, nil)
        end)
    end)

    H.describe("v1 migration", function()
        -- A v1 database has no version stamp and keeps its settings as flat
        -- top-level keys. This shape is what a user upgrading from 1.x has.
        local function v1()
            return {
                showStatPanel = false,
                hideInCombat = true,
                showFPS = false,
                textColor = { 1, 0, 0, 1 },
                updateInterval = 0.5,
                fontSize = 14,
            }
        end

        H.it("carries the old settings into a profile", function()
            local db = freshDB(v1())
            local p = db.profiles.Default
            H.eq(p.enabled, false, "showStatPanel became enabled")
            H.eq(p.panel.hideInCombat, true)
            H.eq(p.footer.showFPS, false)
            H.same(p.font.elements.footer.color, { 1, 0, 0, 1 })
        end)

        H.it("fills in everything v1 never had", function()
            local p = freshDB(v1()).profiles.Default
            H.eq(p.bars.height, DEFAULTS.bars.height)
            H.ok(p.sections, "sections did not exist in v1")
            H.ok(p.stats.Crit, "per-stat config did not exist in v1")
        end)

        H.it("removes the legacy top-level keys", function()
            local db = freshDB(v1())
            for _, key in ipairs({ "showStatPanel", "hideInCombat", "showFPS",
                "textColor", "updateInterval", "fontSize" }) do
                H.eq(db[key], nil, "legacy key '" .. key .. "' was left behind")
            end
        end)

        H.it("does not re-run on an already-migrated database", function()
            local db = freshDB(v1())
            db.profiles.Default.enabled = true      -- the user turned it back on
            db.showStatPanel = false                -- a stale key reappears somehow
            Config:Init()
            H.eq(db.profiles.Default.enabled, true,
                "a stamped database must not be migrated a second time")
        end)

        H.it("leaves a versioned database alone", function()
            local db = freshDB({ version = 2, profiles = {}, chars = {} })
            H.ok(db.profiles.Default, "still gets a Default")
            H.eq(db.version, 2)
        end)
    end)

    H.describe("sanitizing a corrupt profile", function()
        -- The failure this prevents: a wrong-typed value survives into a Set*
        -- call and raises on every login, with the bad profile already saved.
        local function activateWith(mutate)
            local db = freshDB()
            mutate(db.profiles.Default)
            Config:Activate("Default")
            return SP.db
        end

        H.it("replaces a scalar of the wrong type", function()
            local p = activateWith(function(p) p.panel.width = "wide" end)
            H.eq(p.panel.width, DEFAULTS.panel.width)
        end)

        H.it("replaces a table where a scalar belongs", function()
            local p = activateWith(function(p) p.bars.height = { 1, 2, 3 } end)
            H.eq(p.bars.height, DEFAULTS.bars.height)
        end)

        H.it("replaces a scalar where a table belongs", function()
            local p = activateWith(function(p) p.font = "big" end)
            H.eq(type(p.font), "table")
            H.eq(p.font.face, DEFAULTS.font.face)
        end)

        H.it("repairs a short colour array", function()
            -- fillDefaults deliberately won't reach inside a colour, so this is
            -- the only thing standing between {1,0} and SetStatusBarColor.
            local p = activateWith(function(p) p.panel.bgColor = { 1, 0 } end)
            H.eq(#p.panel.bgColor, 4)
        end)

        H.it("repairs a colour with a non-numeric channel", function()
            local p = activateWith(function(p) p.panel.borderColor = { 1, "green", 0, 1 } end)
            H.same(p.panel.borderColor, DEFAULTS.panel.borderColor)
        end)

        H.it("keeps a valid colour untouched", function()
            local p = activateWith(function(p) p.panel.bgColor = { 0.1, 0.2, 0.3, 0.4 } end)
            H.same(p.panel.bgColor, { 0.1, 0.2, 0.3, 0.4 })
        end)

        -- Regression: the colour-repair branch treated a section's stat list as
        -- a fixed-length array, so any section the user had shortened was
        -- "repaired" back to the default membership on the next Activate --
        -- which is every login. Removing a stat did not stick, silently.
        H.it("keeps a stat the user removed from a section removed", function()
            local p = activateWith(function(p)
                p.sections[2].stats = { "Crit", "Haste", "Mastery" }
            end)
            H.same(p.sections[2].stats, { "Crit", "Haste", "Mastery" })
        end)

        H.it("keeps stats the user added to a section", function()
            local p = activateWith(function(p)
                p.sections[2].stats = { "Crit", "Haste", "Mastery", "Versatility", "Leech", "Speed" }
            end)
            H.eq(#p.sections[2].stats, 6)
        end)

        H.it("keeps a section the user emptied", function()
            local p = activateWith(function(p) p.sections[2].stats = {} end)
            H.eq(#p.sections[2].stats, 0)
        end)

        H.it("still drops a non-string from a stat list", function()
            local p = activateWith(function(p)
                p.sections[2].stats = { "Crit", 42, "Haste", {} }
            end)
            H.same(p.sections[2].stats, { "Crit", "Haste" },
                "a garbled entry is dropped, not the whole list")
        end)

        H.it("keeps unknown keys the user carries", function()
            local p = activateWith(function(p) p.somethingFromANewerVersion = 7 end)
            H.eq(p.somethingFromANewerVersion, 7,
                "downgrading must not silently discard settings")
        end)

        H.it("never raises, whatever the profile contains", function()
            for _, mutate in ipairs({
                function(p) p.panel = 5 end,
                function(p) p.stats = "none" end,
                function(p) p.sections = {} end,
                function(p) p.sections = { "not a section" } end,
                function(p) p.font = { elements = { title = false } } end,
                function(p) p.bars = { style = {} } end,
            }) do
                H.noRaise(function() activateWith(mutate) end)
            end
        end)
    end)

    H.describe("mutually exclusive visibility rules", function()
        H.it("breaks a hide/only pair rather than hiding the panel forever", function()
            local db = freshDB()
            db.profiles.Default.panel.hideInCombat = true
            db.profiles.Default.panel.onlyInCombat = true
            Config:Activate("Default")
            H.notOk(SP.db.panel.hideInCombat and SP.db.panel.onlyInCombat,
                "both halves set means the panel never appears, with nothing on screen to say why")
        end)

        H.it("breaks the instance pair too", function()
            local db = freshDB()
            db.profiles.Default.panel.hideInInstance = true
            db.profiles.Default.panel.hideOutOfInstance = true
            Config:Activate("Default")
            H.notOk(SP.db.panel.hideInInstance and SP.db.panel.hideOutOfInstance)
        end)

        H.it("leaves a single rule alone", function()
            local db = freshDB()
            db.profiles.Default.panel.hideInCombat = true
            Config:Activate("Default")
            H.eq(SP.db.panel.hideInCombat, true)
        end)
    end)

    H.describe("profile management", function()
        H.it("creates a profile", function()
            freshDB()
            H.ok(Config:NewProfile("Raiding"))
            H.ok(_G.SPAddonDB.profiles.Raiding)
        end)

        H.it("refuses an empty or duplicate name", function()
            freshDB()
            H.notOk((Config:NewProfile("")))
            H.notOk((Config:NewProfile("   ")))
            Config:NewProfile("Raiding")
            H.notOk((Config:NewProfile("Raiding")))
        end)

        H.it("copies a profile by value, not by reference", function()
            freshDB()
            _G.SPAddonDB.profiles.Default.panel.width = 111
            Config:NewProfile("Copy", "Default")
            _G.SPAddonDB.profiles.Copy.panel.width = 222
            H.eq(_G.SPAddonDB.profiles.Default.panel.width, 111,
                "editing a copy must not reach back into its source")
        end)

        H.it("refuses to delete Default", function()
            freshDB()
            H.notOk((Config:DeleteProfile("Default")))
            H.ok(_G.SPAddonDB.profiles.Default)
        end)

        H.it("repoints characters when their profile is deleted", function()
            local db = freshDB()
            Config:NewProfile("Doomed")
            db.chars["Someone - Elsewhere"] = "Doomed"
            Config:DeleteProfile("Doomed")
            H.eq(db.chars["Someone - Elsewhere"], "Default")
        end)

        H.it("resets one section without touching the rest", function()
            freshDB()
            SP.db.panel.width = 999
            SP.db.bars.height = 42
            Config:Reset("bars")
            H.eq(SP.db.bars.height, DEFAULTS.bars.height)
            H.eq(SP.db.panel.width, 999, "resetting bars must not reset the panel")
        end)
    end)

    H.describe("path access", function()
        H.it("reads and writes a nested path", function()
            freshDB()
            Config:Set("bars.height", 19)
            H.eq(Config:Get("bars.height"), 19)
            H.eq(SP.db.bars.height, 19)
        end)

        H.it("indexes into a list", function()
            freshDB()
            H.eq(Config:Get("sections.1.id"), DEFAULTS.sections[1].id)
        end)

        H.it("returns nil for a path that does not exist", function()
            freshDB()
            H.eq(Config:Get("nope.not.here"), nil)
        end)

        H.it("reads a colour as four channels", function()
            freshDB()
            Config:SetColor("panel.bgColor", 0.1, 0.2, 0.3, 0.4)
            local r, g, b, a = Config:GetColor("panel.bgColor")
            H.eq(r, 0.1) H.eq(g, 0.2) H.eq(b, 0.3) H.eq(a, 0.4)
        end)
    end)

    H.describe("import and export", function()
        H.it("round-trips a profile unchanged", function()
            freshDB()
            SP.db.panel.width = 271
            SP.db.bars.style = "text"
            SP.db.panel.bgColor = { 0.1, 0.2, 0.3, 0.4 }
            SP.db.stats.Crit.format = "$rating - $value%"

            local text = Config:Export("Default")
            H.ok(text, "exported something")

            H.ok(Config:Import(text, "Imported"))
            local imported = _G.SPAddonDB.profiles.Imported
            H.eq(imported.panel.width, 271)
            H.eq(imported.bars.style, "text")
            H.same(imported.panel.bgColor, { 0.1, 0.2, 0.3, 0.4 })
            H.eq(imported.stats.Crit.format, "$rating - $value%")
        end)

        H.it("preserves section order and membership", function()
            freshDB()
            SP.db.sections = {
                { id = "custom", title = "MINE", enabled = true, showHeader = false,
                  stats = { "Haste", "Crit" } },
            }
            H.ok(Config:Import(Config:Export("Default"), "Imported"))
            local sections = _G.SPAddonDB.profiles.Imported.sections
            H.eq(#sections, 1, "sections replace wholesale, they do not merge")
            H.eq(sections[1].id, "custom")
            H.same(sections[1].stats, { "Haste", "Crit" })
        end)

        H.it("survives quotes, backslashes and newlines in free text", function()
            freshDB()
            SP.db.panel.titleText = [[He said "hi" \ then |cffff0000red|r]] .. "\n%d%%"
            H.ok(Config:Import(Config:Export("Default"), "Imported"))
            H.eq(_G.SPAddonDB.profiles.Imported.panel.titleText, SP.db.panel.titleText)
        end)

        H.it("fills in keys the exporting version did not have", function()
            -- Importing a string from an older StatPanel must not leave holes.
            freshDB()
            local text = Config:Export("Default")
            H.ok(Config:Import(text, "Imported"))
            local imported = _G.SPAddonDB.profiles.Imported
            H.ok(imported.footer, "footer block present")
            H.ok(imported.announce, "announce block present")
        end)

        H.it("rejects anything that is not an export string", function()
            freshDB()
            for _, bad in ipairs({ "", "hello", "SP1!", "SP2!abcdef",
                "not even close", "{panel={width=200}}" }) do
                local name, err = Config:Import(bad, "Imported")
                H.eq(name, nil, "rejected: " .. bad)
                H.eq(type(err), "string", "gave a reason for: " .. bad)
            end
        end)

        H.it("rejects nil and non-strings", function()
            freshDB()
            H.eq((Config:Import(nil, "X")), nil)
            H.eq((Config:Import(42, "X")), nil)
            H.eq((Config:Import({}, "X")), nil)
        end)

        H.it("rejects a corrupt payload without raising", function()
            freshDB()
            local text = Config:Export("Default")
            -- Truncate the base64 body: valid prefix, unloadable content.
            H.noRaise(function() Config:Import(text:sub(1, #text - 40), "Imported") end)
        end)

        H.it("rejects an oversize string before trying to load it", function()
            freshDB()
            local huge = "SP1!" .. string.rep("A", 300000)
            local name, err = Config:Import(huge, "Imported")
            H.eq(name, nil)
            H.ok(err and err:find("large"), "says why")
        end)

        H.it("does not execute code in an import string", function()
            freshDB()
            _G.__importEscaped = nil
            -- A table constructor that would set a global if it ran with the
            -- real environment. loadstring runs it in an empty one instead.
            local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
            local payload = "{x=(function() __importEscaped = true return 1 end)()}"
            local encoded = {}
            for i = 1, #payload, 3 do
                local a, b, c = payload:byte(i, i + 2)
                local n = a * 65536 + (b or 0) * 256 + (c or 0)
                local c1 = math.floor(n / 262144) % 64
                local c2 = math.floor(n / 4096) % 64
                local c3 = math.floor(n / 64) % 64
                local c4 = n % 64
                encoded[#encoded + 1] = B64:sub(c1 + 1, c1 + 1) .. B64:sub(c2 + 1, c2 + 1)
                    .. (b and B64:sub(c3 + 1, c3 + 1) or "=")
                    .. (c and B64:sub(c4 + 1, c4 + 1) or "=")
            end
            H.noRaise(function() Config:Import("SP1!" .. table.concat(encoded), "Evil") end)
            H.notOk(_G.__importEscaped,
                "an import string must not be able to reach the game's globals")
        end)

        H.it("tolerates whitespace a chat client inserted", function()
            freshDB()
            local text = Config:Export("Default")
            local wrapped = text:gsub("(................................)", "%1\n  ")
            H.ok(Config:Import(wrapped, "Imported"), "line breaks are stripped before decoding")
        end)

        H.it("returns nil for a profile that does not exist", function()
            freshDB()
            H.eq(Config:Export("No Such Profile"), nil)
        end)
    end)
end
