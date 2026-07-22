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

AutoProfile.contexts = {
    { name = "Open world",   value = "world" },
    { name = "Dungeon",      value = "dungeon" },
    { name = "Raid",         value = "raid" },
    { name = "Arena",        value = "arena" },
    { name = "Battleground", value = "battleground" },
    { name = "Scenario",     value = "scenario" },
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
    return CONTEXT_FROM_INSTANCE[instanceType] or "world"
end

-- Returns the profile the current situation calls for, or nil for "no rule".
function AutoProfile:Resolve()
    local settings = self:Settings()
    if not settings.enabled then return nil end

    -- Context first: where you are is a stronger signal than what you are.
    local contextProfile = settings.byContext[self:CurrentContext()]
    if contextProfile and SPAddonDB.profiles[contextProfile] then
        return contextProfile, "context"
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
        SP:Print(string.format("switched to profile '%s' (%s rule).", target, reason))
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
