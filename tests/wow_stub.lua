-- tests/wow_stub.lua (A World of Warcraft client, for a value of "client")
--
-- The addon's pure logic -- priority parsing, value templating, the profile
-- schema, import/export -- has no business needing a running game, but it does
-- need the global environment one provides. This file supplies enough of that
-- environment for the addon's files to LOAD, so the interesting functions can
-- then be called directly.
--
-- Deliberately not a simulator. Nothing here models game behaviour; the numbers
-- are plausible constants and the widgets are inert. If a test starts wanting
-- realistic API behaviour, that is a sign the logic under test should be pulled
-- out of the rendering path instead.
--
-- Two rules worth keeping:
--   * Only add what a file needs to load or a test needs to run. An unused stub
--     is a claim about the API that nothing checks.
--   * Never make a stub cleverer than the real API. A stub that tolerates what
--     the game rejects turns a green test suite into a false negative.

local M = {}

--------------------------------------------------------------------------------
-- WIDGETS
--------------------------------------------------------------------------------
-- One inert object stands in for frames, textures and font strings alike. The
-- real hierarchy distinguishes them; nothing under test does.

local widget = {}

-- Methods that must return something usable, because callers do arithmetic on
-- the result or index into it. Everything else no-ops.
local RETURNS = {
    GetWidth = function() return 200 end,
    GetHeight = function() return 20 end,
    GetStringWidth = function() return 42 end,
    GetUnboundedStringWidth = function() return 42 end,
    GetScale = function() return 1 end,
    GetEffectiveScale = function() return 1 end,
    GetAlpha = function() return 1 end,
    GetFrameLevel = function() return 10 end,
    GetNumPoints = function() return 1 end,
    GetLeft = function() return 0 end,
    GetRight = function() return 200 end,
    GetTop = function() return 200 end,
    GetBottom = function() return 0 end,
    GetCenter = function() return 100, 100 end,
    GetObjectType = function() return "Frame" end,
    GetFont = function() return [[Fonts\FRIZQT__.TTF]], 12, "" end,
    GetPoint = function() return "CENTER", nil, "CENTER", 0, 0 end,
    GetText = function(self) return self.__text end,
    IsShown = function(self) return self.__shown ~= false end,
    IsVisible = function(self) return self.__shown ~= false end,
    IsMouseOver = function() return false end,
    IsForbidden = function() return false end,
    -- The secret-value guard rails. A stub widget never holds secrets; tests
    -- that care drive SP.PlainNumber and issecretvalue directly instead.
    HasSecretValues = function() return false end,
}

local creators = {
    CreateTexture = true, CreateFontString = true, CreateLine = true,
    CreateMaskTexture = true, CreateAnimationGroup = true,
}

local function newWidget(frameType, name, parent)
    local w = {
        __type = frameType or "Frame",
        __name = name,
        __parent = parent,
        __scripts = {},
        __events = {},
    }
    return setmetatable(w, widget)
end
M.NewWidget = newWidget

widget.__index = function(self, key)
    local canned = RETURNS[key]
    if canned then return canned end

    if creators[key] then
        return function(s) return newWidget("Texture", nil, s) end
    end

    if key == "SetText" or key == "SetFormattedText" then
        return function(s, fmt, ...)
            -- Formatting for real is the point: a bad template must still raise
            -- here, exactly as SetFormattedText would in the game.
            s.__text = select("#", ...) > 0 and string.format(fmt, ...) or fmt
        end
    end

    if key == "Show" then return function(s) s.__shown = true end end
    if key == "Hide" then return function(s) s.__shown = false end end
    if key == "SetShown" then return function(s, v) s.__shown = v and true or false end end

    if key == "SetScript" then
        return function(s, event, fn) s.__scripts[event] = fn end
    end
    if key == "GetScript" then
        return function(s, event) return s.__scripts[event] end
    end
    if key == "RegisterEvent" or key == "RegisterUnitEvent" then
        return function(s, event) s.__events[event] = true end
    end
    if key == "UnregisterEvent" then
        return function(s, event) s.__events[event] = nil end
    end

    -- Anything else is a setter or a no-op query. Returning a shared no-op
    -- rather than nil is what lets 1600 lines of frame construction run.
    return function() end
end

--------------------------------------------------------------------------------
-- INSTALL
--------------------------------------------------------------------------------
-- `env` is the table the addon sees as its global environment. Passing _G is
-- the normal case; a test that wants isolation can pass its own.
function M.install(env)
    env = env or _G

    local function def(name, value)
        if env[name] == nil then env[name] = value end
    end

    ----------------------------------------------------------------------------
    -- Lua extensions the game adds
    ----------------------------------------------------------------------------
    def("wipe", function(t) for k in pairs(t) do t[k] = nil end return t end)
    def("strtrim", function(s, chars)
        chars = chars or " \t\r\n"
        local pattern = "[" .. chars:gsub("(%W)", "%%%1") .. "]"
        return (s:gsub("^" .. pattern .. "+", ""):gsub(pattern .. "+$", ""))
    end)
    def("strsplit", function(sep, str, limit)
        local out, count = {}, 0
        local pattern = "([^" .. sep:gsub("(%W)", "%%%1") .. "]*)"
        for piece in str:gmatch(pattern .. "[" .. sep:gsub("(%W)", "%%%1") .. "]?") do
            count = count + 1
            out[count] = piece
            if limit and count >= limit then break end
        end
        return unpack(out, 1, count)
    end)
    def("strjoin", function(sep, ...) return table.concat({ ... }, sep) end)
    def("tostringall", function(...) return ... end)

    -- The game adds these as string methods; the addon calls ("x"):trim().
    if not ("" ).trim then
        local meta = getmetatable("")
        meta.__index.trim = function(s) return env.strtrim(s) end
    end

    ----------------------------------------------------------------------------
    -- Secret values (patch 12.0)
    ----------------------------------------------------------------------------
    -- No stub value is ever secret. The addon's own guards are what tests
    -- exercise, and a fake secret that Lua can still add and compare would
    -- prove nothing about the real one.
    def("issecretvalue", function() return false end)
    def("issecrettable", function() return false end)
    def("hasanysecretvalues", function() return false end)
    def("canaccessvalue", function() return true end)
    def("scrubsecretvalues", function(v) return v end)

    ----------------------------------------------------------------------------
    -- Core UI
    ----------------------------------------------------------------------------
    def("UIParent", newWidget("Frame", "UIParent"))
    def("Minimap", newWidget("Frame", "Minimap"))
    def("GameTooltip", newWidget("GameTooltip", "GameTooltip"))
    def("ChatFontNormal", newWidget("FontString", "ChatFontNormal"))
    def("GameFontNormal", newWidget("FontString", "GameFontNormal"))
    def("ColorPickerFrame", newWidget("Frame", "ColorPickerFrame"))
    def("SettingsPanel", newWidget("Frame", "SettingsPanel"))
    def("STANDARD_TEXT_FONT", [[Fonts\FRIZQT__.TTF]])

    def("CreateFrame", function(frameType, name, parent)
        local f = newWidget(frameType, name, parent)
        if name then env[name] = f end
        return f
    end)

    def("Mixin", function(target, ...)
        for i = 1, select("#", ...) do
            for k, v in pairs((select(i, ...))) do target[k] = v end
        end
        return target
    end)
    def("BackdropTemplateMixin", { OnBackdropLoaded = function() end })

    def("C_Timer", {
        After = function(_, fn) return fn end,   -- never fires; tests are synchronous
        NewTicker = function() return { Cancel = function() end } end,
    })

    def("Settings", {
        RegisterCanvasLayoutCategory = function() return { ID = 1 } end,
        RegisterAddOnCategory = function() end,
        OpenToCategory = function() end,
    })

    def("SlashCmdList", {})
    def("GetCursorPosition", function() return 0, 0 end)
    def("GetTime", function() return 1000 end)
    def("IsLoggedIn", function() return true end)
    def("InCombatLockdown", function() return false end)
    def("LibStub", nil)   -- no libraries: the addon must work without them

    ----------------------------------------------------------------------------
    -- Character and stats
    ----------------------------------------------------------------------------
    def("GetLocale", function() return "enUS" end)
    def("GetBuildInfo", function() return "12.0.7", "62000", "Jul 27 2026", 120007 end)
    def("UnitName", function() return "Teststrider" end)
    def("GetRealmName", function() return "Test Realm" end)
    def("UnitClass", function() return "Hunter", "HUNTER", 3 end)
    def("UnitLevel", function() return 80 end)
    def("UnitExists", function() return true end)
    def("UnitIsDeadOrGhost", function() return false end)
    def("UnitInVehicle", function() return false end)
    def("UnitClassification", function() return "normal" end)
    def("UnitArmor", function() return 0, 5000, 0, 0, 0 end)
    def("UnitStat", function(_, index) return 100 * index, 100 * index, 0, 0 end)
    def("UnitHealth", function() return 500000 end)
    def("UnitHealthMax", function() return 1000000 end)
    def("UnitPower", function() return 50000 end)
    def("UnitPowerMax", function() return 100000 end)
    def("UnitPowerType", function() return 0, "MANA" end)
    def("UnitAttackPower", function() return 8000, 0, 0 end)
    def("UnitRangedAttackPower", function() return 8000, 0, 0 end)
    def("UnitStagger", function() return 12000 end)

    def("GetSpecialization", function() return 1 end)
    def("GetSpecializationInfo", function() return 253, "Beast Mastery" end)
    def("GetCombatRating", function() return 1500 end)
    def("GetCombatRatingBonus", function() return 12.5 end)
    def("GetCritChance", function() return 22.5 end)
    def("GetSpellCritChance", function() return 22.5 end)
    def("GetHaste", function() return 18.25 end)
    def("GetMasteryEffect", function() return 30.5 end)
    def("GetDodgeChance", function() return 5.5 end)
    def("GetParryChance", function() return 0 end)
    def("GetBlockChance", function() return 0 end)
    def("GetLifesteal", function() return 2.5 end)
    def("GetAvoidance", function() return 3.5 end)
    def("GetManaRegen", function() return 100, 200 end)
    def("GetAverageItemLevel", function() return 226.06, 228.19 end)
    def("GetUnitSpeed", function() return 7 end)
    def("GetSpellBonusDamage", function() return 9000 end)
    def("GetSpellBonusHealing", function() return 9000 end)

    def("IsInInstance", function() return false, "none" end)
    def("GetInstanceInfo", function() return "Test", "none" end)
    def("IsInGroup", function() return false end)
    def("IsInRaid", function() return false end)
    def("IsInGuild", function() return false end)
    def("IsPlayerMoving", function() return false end)
    def("IsFlying", function() return false end)

    ----------------------------------------------------------------------------
    -- Items
    ----------------------------------------------------------------------------
    def("GetInventoryItemLink", function() return nil end)
    def("GetInventoryItemID", function() return nil end)
    def("GetInventoryItemDurability", function() return nil end)
    def("GetInventoryAlertStatus", function() return nil end)
    def("GetRepairAllCost", function() return 0, false end)
    def("GetMoney", function() return 12345678 end)
    def("GetItemStats", function() return {} end)
    def("GetDetailedItemLevelInfo", function() return 226 end)
    def("GetInventorySlotInfo", function() return 1 end)

    ----------------------------------------------------------------------------
    -- Namespaced APIs
    ----------------------------------------------------------------------------
    def("C_PetBattles", { IsInBattle = function() return false end })
    def("C_PlayerInfo", { GetClass = function() return nil end })
    def("C_SpecializationInfo", { GetSpecialization = function() return 1 end })
    def("C_Item", {
        GetItemInfo = function() return nil end,
        GetCurrentItemLevel = function() return 226 end,
        DoesItemExistByID = function() return false end,
    })
    def("C_ChatInfo", { SendAddonMessage = function() end })
    def("C_AddOns", {
        IsAddOnLoaded = function() return false end,
        -- The real TOC version, supplied by run.lua. Inventing one here would
        -- mean the what's-new notice was tested against a number that ships
        -- nowhere, which is the one number it must agree with.
        GetAddOnMetadata = function(_, field)
            if field == "Version" then return env.__TOC_VERSION or "0.0.0" end
            return nil
        end,
        GetAddOnInfo = function() return nil end,
    })
    def("C_PaperDollInfo", { GetInspectItemLevel = function() return 0 end })
    def("C_TooltipInfo", { GetInventoryItem = function() return nil end })
    def("C_CVar", { GetCVar = function() return "0" end })
    def("TooltipUtil", { SurfaceArgs = function() end })
    def("MenuUtil", { CreateContextMenu = function() end })
    def("MenuResponse", { Refresh = 1, Close = 2 })

    ----------------------------------------------------------------------------
    -- Chat and performance
    ----------------------------------------------------------------------------
    def("SendChatMessage", function() end)
    def("GetFramerate", function() return 144 end)
    def("GetNetStats", function() return 0, 0, 35, 40 end)
    def("UpdateAddOnMemoryUsage", function() end)
    def("GetAddOnMemoryUsage", function() return 512 end)
    def("BreakUpLargeNumbers", function(n)
        local s = tostring(math.floor(tonumber(n) or 0))
        local sign, digits = s:match("^(%-?)(%d+)$")
        digits = digits:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
        return sign .. digits
    end)

    ----------------------------------------------------------------------------
    -- Constants
    ----------------------------------------------------------------------------
    def("BASE_MOVEMENT_SPEED", 7)
    def("RAID_CLASS_COLORS", {
        HUNTER = { r = 0.67, g = 0.83, b = 0.45, colorStr = "ffabd473" },
    })

    for index, name in ipairs({ "CR_CRIT_MELEE", "CR_HASTE_MELEE", "CR_MASTERY",
        "CR_VERSATILITY_DAMAGE_DONE", "CR_DODGE", "CR_PARRY", "CR_BLOCK",
        "CR_LIFESTEAL", "CR_AVOIDANCE", "CR_SPEED" }) do
        def(name, index)
    end

    -- GlobalStrings. SP.Global prefers these to the addon's own locale table,
    -- so leaving them out would silently test a different code path than the
    -- one that runs in game.
    local GLOBALS = {
        SPELL_STAT1_NAME = "Strength", SPELL_STAT2_NAME = "Agility",
        SPELL_STAT3_NAME = "Stamina",  SPELL_STAT4_NAME = "Intellect",
        STAT_CRITICAL_STRIKE = "Critical Strike", STAT_HASTE = "Haste",
        STAT_MASTERY = "Mastery", STAT_VERSATILITY = "Versatility",
        DODGE = "Dodge", PARRY = "Parry", BLOCK = "Block",
        STAT_LIFESTEAL = "Leech", STAT_AVOIDANCE = "Avoidance",
        STAT_SPEED = "Speed", STAT_ATTACK_POWER = "Attack Power",
        STAT_SPELLPOWER = "Spell Power", HEALTH = "Health", MANA = "Mana",
        HEADSLOT = "Head", NECKSLOT = "Neck", SHOULDERSLOT = "Shoulder",
        BACKSLOT = "Back", CHESTSLOT = "Chest", WRISTSLOT = "Wrist",
        HANDSSLOT = "Hands", WAISTSLOT = "Waist", LEGSSLOT = "Legs",
        FEETSLOT = "Feet", FINGER0SLOT = "Finger", TRINKET0SLOT = "Trinket",
        MAINHANDSLOT = "Main Hand", SECONDARYHANDSLOT = "Off Hand",
    }
    for name, value in pairs(GLOBALS) do def(name, value) end

    return env
end

return M
