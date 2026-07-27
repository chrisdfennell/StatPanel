-- AutoProfile.lua (Switch profiles automatically by spec or content)
--
-- Rules are stored per character, because spec IDs and the way you play each
-- alt are per character. A context rule (raid / dungeon / PvP) wins over a spec
-- rule, so you can say "Tank profile for Protection, but always Raid Ready in a
-- raid" and get both.
--
-- Nothing switches unless you have explicitly set a rule; an unmapped spec or
-- context leaves whatever profile you are on alone.

local addonName, SP = ...
local L = SP.L

local AutoProfile = {}
SP.AutoProfile = AutoProfile

-- IsInInstance() instanceType -> our context key.
local CONTEXT_FROM_INSTANCE = {
    raid     = "raid",
    party    = "dungeon",
    pvp      = "battleground",
    arena    = "arena",
    scenario = "scenario",
}

-- Delves and Mythic+ keys are not their own instance types - a delve reports as
-- a scenario and a key reports as a party dungeon, exactly like their untimed
-- counterparts. The difficulty ID is the only thing that separates them.
-- From the DifficultyID table: 208 is "Delves", 8 is "Mythic Keystone".
local DIFFICULTY_DELVE           = 208
local DIFFICULTY_MYTHIC_KEYSTONE = 8

-- A specific context falls back to its general one, so somebody who already had
-- a "Dungeon" rule before these existed still gets that profile inside a key
-- unless they deliberately set a different rule for Mythic+.
local CONTEXT_FALLBACK = {
    delve      = "scenario",
    mythicplus = "dungeon",
}

AutoProfile.contexts = {
    { name = L["Open world"],      value = "world" },
    { name = L["Delve"],           value = "delve" },
    { name = L["Dungeon"],         value = "dungeon" },
    { name = L["Mythic+ dungeon"], value = "mythicplus" },
    { name = L["Raid"],            value = "raid" },
    { name = L["Arena"],           value = "arena" },
    { name = L["Battleground"],    value = "battleground" },
    { name = L["Scenario"],        value = "scenario" },
}

--------------------------------------------------------------------------------
-- STORAGE
--------------------------------------------------------------------------------
function AutoProfile:Settings()
    SPAddonDB.autoProfile = SPAddonDB.autoProfile or {}

    local key = SP.Config:CharKey()
    local settings = SPAddonDB.autoProfile[key]
    if not settings then
        settings = { enabled = false, bySpec = {}, byContext = {} }
        SPAddonDB.autoProfile[key] = settings
    end

    settings.bySpec = settings.bySpec or {}
    settings.byContext = settings.byContext or {}
    return settings
end

--------------------------------------------------------------------------------
-- RESOLUTION
--------------------------------------------------------------------------------
function AutoProfile:CurrentContext()
    local inInstance, instanceType = IsInInstance()
    if not inInstance then return "world" end

    local difficultyID = select(3, GetInstanceInfo())
    if instanceType == "scenario" and difficultyID == DIFFICULTY_DELVE then
        return "delve"
    end
    if instanceType == "party" and difficultyID == DIFFICULTY_MYTHIC_KEYSTONE then
        return "mythicplus"
    end

    return CONTEXT_FROM_INSTANCE[instanceType] or "world"
end

-- Returns the profile the current situation calls for, or nil for "no rule".
function AutoProfile:Resolve()
    local settings = self:Settings()
    if not settings.enabled then return nil end

    -- Context first: where you are is a stronger signal than what you are.
    -- Walk from the most specific context to its general one, so a Mythic+ rule
    -- wins inside a key but a plain Dungeon rule still applies without one.
    local context = self:CurrentContext()
    while context do
        local contextProfile = settings.byContext[context]
        if contextProfile and SPAddonDB.profiles[contextProfile] then
            return contextProfile, "context"
        end
        context = CONTEXT_FALLBACK[context]
    end

    local _, _, specID = SP:GetCurrentPriority()
    if specID then
        local specProfile = settings.bySpec[specID]
        if specProfile and SPAddonDB.profiles[specProfile] then
            return specProfile, "spec"
        end
    end

    return nil
end

-- Applies the resolved profile if it differs from the active one.
function AutoProfile:Apply(announce)
    local target, reason = self:Resolve()
    if not target or target == SP.Config:CurrentProfile() then return false end

    SP.Config:SetProfile(target)
    if SP.UI then SP.UI:RefreshAll() end

    if announce ~= false then
        SP:Print(string.format(L["switched to profile '%s' (%s rule)."], target, reason))
    end
    return true
end

--------------------------------------------------------------------------------
-- EVENTS
--------------------------------------------------------------------------------
local watcher = CreateFrame("Frame")
watcher:RegisterEvent("PLAYER_ENTERING_WORLD")
watcher:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
watcher:RegisterEvent("ZONE_CHANGED_NEW_AREA")

watcher:SetScript("OnEvent", function(_, event, unit)
    if not SP.db or not SPAddonDB then return end
    if event == "PLAYER_SPECIALIZATION_CHANGED" and unit and unit ~= "player" then return end

    -- Deferred: spec and instance info are not reliably settled at the moment
    -- these events fire, and a wrong answer would switch the wrong profile.
    C_Timer.After(1, function()
        if SP.AutoProfile then SP.AutoProfile:Apply() end
    end)
end)
