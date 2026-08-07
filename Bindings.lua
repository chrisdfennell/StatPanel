-- Bindings.lua (Key bindings)
--
-- Bindings.xml declares the bindings and calls the handlers below; this file
-- supplies their names, because the names are user-facing text and belong in
-- SP.L like everything else. Blizzard reads BINDING_NAME_<ACTION> out of the
-- global environment when it draws the Key Bindings window, so these have to be
-- real globals -- there is no registration API.
--
-- Every handler here has to be safe to run at any moment, including mid-combat
-- and while the options window is closed. None of them touch a protected frame
-- or a secure template, so none of them can taint anything; the panel is a
-- plain frame and hiding it in combat is allowed.

local addonName, SP = ...
local L = SP.L

_G.BINDING_HEADER_STATPANEL = "StatPanel"
_G.BINDING_NAME_STATPANEL_TOGGLE      = L["Show or hide the panel"]
_G.BINDING_NAME_STATPANEL_OPTIONS     = L["Open the options"]
_G.BINDING_NAME_STATPANEL_LOCK        = L["Lock or unlock the panel"]
_G.BINDING_NAME_STATPANEL_NEXTPROFILE = L["Switch to the next profile"]
_G.BINDING_NAME_STATPANEL_GEAR        = L["Run the gear audit"]

local Bindings = {}
SP.Bindings = Bindings

-- A binding can fire before PLAYER_LOGIN has built anything -- the key is live
-- as soon as the bindings file loads. Every handler goes through this.
local function ready()
    return SP.ready and SP.db ~= nil
end

function Bindings:Toggle()
    if not ready() then return end
    SP:Print(SP:TogglePanel() and L["panel shown."] or L["panel hidden."])
end

function Bindings:Options()
    if not ready() then return end
    SP:OpenOptions()
end

function Bindings:Lock()
    if not ready() then return end
    SP.db.panel.locked = not SP.db.panel.locked
    SP:Print(SP.db.panel.locked and L["panel locked."] or L["panel unlocked."])
    SP.UI:RefreshAll()
end

-- Cycles through the profile list in the same order the options window shows
-- it, wrapping at the end. With one profile this is a no-op that says so rather
-- than appearing to do nothing.
function Bindings:NextProfile()
    if not ready() then return end

    local list = SP.Config:ProfileList()
    if #list < 2 then
        SP:Print(L["only one profile exists."])
        return
    end

    local current = SP.Config:CurrentProfile()
    local index = 1
    for i, name in ipairs(list) do
        if name == current then index = i break end
    end

    local nextName = list[(index % #list) + 1]
    if SP.Config:SetProfile(nextName) then
        SP:Print(L["switched to profile '%s'."]:format(nextName))
        SP.UI:RefreshAll()
    end
end

function Bindings:Gear()
    if not ready() then return end
    SP.Gear:PrintReport()
end

-- Bindings.xml calls these by name: the XML body is a chunk in the global
-- environment and cannot see this file's locals.
function StatPanel_BindingToggle()      Bindings:Toggle() end
function StatPanel_BindingOptions()     Bindings:Options() end
function StatPanel_BindingLock()        Bindings:Lock() end
function StatPanel_BindingNextProfile() Bindings:NextProfile() end
function StatPanel_BindingGear()        Bindings:Gear() end
