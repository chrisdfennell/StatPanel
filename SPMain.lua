-- SPMain.lua (Initialization and slash commands)

local addonName, SP = ...
local L = SP.L

local PREFIX = "|cff88bbffStatPanel|r: "

function SP:Print(...)
    if select("#", ...) == 0 then return end
    print(PREFIX .. table.concat({ tostringall(...) }, " "))
end

--------------------------------------------------------------------------------
-- STARTUP
--------------------------------------------------------------------------------
local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:RegisterEvent("PLAYER_LOGIN")

loader:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        -- Saved variables are readable from here on: build the profile store
        -- first, since both the panel and the options read out of SP.db.
        SP.Config:Init()
        self:UnregisterEvent("ADDON_LOADED")

        -- If we somehow loaded after login, PLAYER_LOGIN will never fire.
        if IsLoggedIn() then
            SP:Setup()
            self:UnregisterEvent("PLAYER_LOGIN")
        end

    elseif event == "PLAYER_LOGIN" then
        -- Wait for login so spec, item level and stats are actually available;
        -- ADDON_LOADED fires too early for GetSpecialization to be reliable.
        SP:Setup()
        self:UnregisterEvent("PLAYER_LOGIN")
    end
end)

function SP:Setup()
    if self.ready then return end
    self.ready = true

    SP:CreatePanel()
    SP:CreateOptionsPanel()
    SP.Broker:Init()
end

--------------------------------------------------------------------------------
-- SLASH COMMANDS
--------------------------------------------------------------------------------
local function usage()
    SP:Print(L["commands:"])
    print(L["  |cffffd100/sp|r - open the options"])
    print(L["  |cffffd100/sp toggle|r - show or hide the panel"])
    print(L["  |cffffd100/sp lock|r - lock or unlock dragging"])
    print(L["  |cffffd100/sp reset|r - move the panel back to the center"])
    print(L["  |cffffd100/sp preset <name>|r - apply a preset (%s)"]:format(table.concat(SP.Presets.order, ", ")))
    print(L["  |cffffd100/sp profile <name>|r - switch profiles"])
    print(L["  |cffffd100/sp peak|r - report and clear the session speed record"])
    print(L["  |cffffd100/sp minimap|r - show or hide the minimap button"])
    print(L["  |cffffd100/sp gear|r - audit enchants, sockets and item level"])
    print(L["  |cffffd100/sp announce [channel]|r - report your gear to chat"])
end

SLASH_STATPANEL1 = "/sp"
SLASH_STATPANEL2 = "/statpanel"

SlashCmdList["STATPANEL"] = function(input)
    input = (input or ""):trim()
    local command, rest = input:match("^(%S*)%s*(.-)$")
    command = (command or ""):lower()

    if command == "" or command == "config" or command == "options" then
        SP:OpenOptions()

    elseif command == "toggle" then
        SP:Print(SP:TogglePanel() and L["panel shown."] or L["panel hidden."])

    elseif command == "lock" then
        SP.db.panel.locked = not SP.db.panel.locked
        SP:Print(SP.db.panel.locked and L["panel locked."] or L["panel unlocked."])
        SP.UI:RefreshAll()

    elseif command == "reset" then
        SP.db.panel.pos = SP.Config:DeepCopy(SP.Config.DEFAULTS.panel.pos)
        SP:Refresh()
        SP:Print(L["position reset."])

    elseif command == "preset" then
        if SP.Presets:Apply(rest) then
            SP:Print(L["applied the '%s' preset."]:format(rest))
            SP.UI:RefreshAll()
        else
            SP:Print(L["unknown preset. Available: %s"]:format(table.concat(SP.Presets.order, ", ")))
        end

    elseif command == "profile" then
        if rest ~= "" and SP.Config:SetProfile(rest) then
            SP:Print(L["switched to profile '%s'."]:format(rest))
            SP.UI:RefreshAll()
        else
            SP:Print(L["profiles: %s"]:format(table.concat(SP.Config:ProfileList(), ", ")))
        end

    elseif command == "peak" then
        SP:ResetPeakSpeed()
        SP:Print(L["session speed record cleared."])

    elseif command == "gear" then
        SP.Gear:PrintReport()

    elseif command == "announce" then
        -- "/sp announce whisper Name" and "/sp announce party" both work.
        local channel, target = rest:match("^(%S*)%s*(.-)$")
        if channel == "" then
            SP.Announce:Send(SP.db.announce.channel)
        else
            SP.Announce:Send(channel:upper(), target)
        end

    elseif command == "minimap" then
        SP.Broker:SetHidden(not SPAddonDB.global.minimap.hide)
        SP:Print(SPAddonDB.global.minimap.hide and L["minimap button hidden."]
            or L["minimap button shown."])

    else
        usage()
    end
end
