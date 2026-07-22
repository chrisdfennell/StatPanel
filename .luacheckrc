-- Luacheck configuration for a World of Warcraft addon.
--
-- The game supplies a large global environment that luacheck knows nothing
-- about, so the API surface this addon touches is declared below. Anything
-- genuinely undefined still gets reported, which is the point.

std = "lua51"

-- WoW source is conventionally wide, and long comment lines are deliberate.
max_line_length = false

-- Loading order means every file is a separate chunk with its own upvalues;
-- unused locals in that style are noise rather than signal.
unused = false

ignore = {
    "212",  -- unused argument (event handlers take args they don't all use)
    "431",  -- shadowing an upvalue (self inside nested closures)
    "432",  -- shadowing an upvalue argument
    "542",  -- empty if branch
}

-- Globals this addon creates or writes to. ColorPickerFrame and SlashCmdList
-- are Blizzard's, but registering a slash command and driving the colour picker
-- both mean assigning into them, so they belong here rather than read_globals.
globals = {
    "SPAddonDB",
    "SLASH_STATPANEL1",
    "SLASH_STATPANEL2",
    "SlashCmdList",
    "ColorPickerFrame",
    -- Kept for backwards compatibility with the 1.x entry points.
    "CreateStatPanel",
    "ToggleStatPanel",
    "SPAddon_StatPanel",
    "SPAddon_ApplyVisibility",
    "SPAddon_CreateOptionsPanel",
    "SPAddon_UpdateStatPanelVisibility",
}

read_globals = {
    -- Lua extensions the game adds
    "wipe", "tostringall", "strtrim", "strsplit", "strjoin",
    "loadstring", "setfenv", "unpack",

    -- Core UI
    "CreateFrame", "UIParent", "GameTooltip", "Minimap", "ChatFontNormal",
    "BackdropTemplateMixin", "Mixin", "OpacitySliderFrame",
    "SettingsPanel", "Settings", "MenuUtil", "MenuResponse", "LibStub",
    "GetCursorPosition", "GetTime", "IsLoggedIn", "InCombatLockdown",

    -- Namespaced APIs
    "C_Timer", "C_PlayerInfo", "C_PetBattles", "C_SpecializationInfo",
    "C_Item", "C_ChatInfo", "C_AddOns", "C_PaperDollInfo",

    -- Character and stats
    "UnitName", "UnitClass", "UnitLevel", "UnitExists", "UnitArmor", "UnitStat",
    "UnitClassification", "UnitIsDeadOrGhost", "UnitInVehicle", "UnitPowerBarID",
    "GetSpecialization", "GetSpecializationInfo",
    "GetCombatRating", "GetCombatRatingBonus", "GetCritChance", "GetHaste",
    "GetMasteryEffect", "GetDodgeChance", "GetParryChance", "GetBlockChance",
    "GetLifesteal", "GetAvoidance", "GetSpellCritChance",
    "GetAverageItemLevel", "GetUnitSpeed", "GetRealmName",
    "IsInInstance", "GetInstanceInfo", "IsInGroup", "IsInRaid", "IsInGuild",
    "IsPlayerMoving", "IsFlying",

    -- Items
    "GetInventoryItemLink", "GetItemStats", "GetDetailedItemLevelInfo",

    -- Chat and performance
    "SendChatMessage", "GetFramerate", "GetNetStats",
    "UpdateAddOnMemoryUsage", "GetAddOnMemoryUsage",

    -- Secret values (patch 12.0)
    "issecretvalue", "issecrettable", "hasanysecretvalues",
    "canaccessvalue", "scrubsecretvalues",

    -- Constants
    "BASE_MOVEMENT_SPEED", "RAID_CLASS_COLORS", "BreakUpLargeNumbers",
    "CR_CRIT_MELEE", "CR_HASTE_MELEE", "CR_MASTERY",
    "CR_VERSATILITY_DAMAGE_DONE", "CR_DODGE", "CR_PARRY", "CR_BLOCK",
    "CR_LIFESTEAL", "CR_AVOIDANCE", "CR_SPEED",

    -- Optional third-party addons we detect but never require
    "ElvUI",
}

-- CI installs Lua and LuaRocks into the workspace, so their own sources would
-- otherwise be linted alongside the addon.
exclude_files = {
    ".luacheckrc",
    ".lua/**/*.lua",
    ".luarocks/**/*.lua",
    ".install/**/*.lua",
}
