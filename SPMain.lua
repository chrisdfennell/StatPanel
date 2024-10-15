local addonName, addonTable = ...
local eventFrame = CreateFrame("Frame")

-- Register ADDON_LOADED event
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, arg1)
    if arg1 == addonName then
        -- Initialize DB if it's nil
        if not SPAddonDB then
            SPAddonDB = {
                updateInterval = 1.0,
                showFPS = true,
                showHomeLatency = true,
                showWorldLatency = true,
                showStatPanel = true,
                showEnhancements = true,
                showDefense = true,
                showSupplementary = true,
            }
        end

        -- Call the functions from the other files
        if SPAddon_CreateOptionsPanel then
            SPAddon_CreateOptionsPanel() -- Ensure the function exists before calling it
        else
            print("Error: SPAddon_CreateOptionsPanel is not defined.")
        end

        -- Create StatPanel after ensuring the saved variables are loaded
        SPAddon_StatPanel = CreateStatPanel()
        if not SPAddonDB.showStatPanel then
            SPAddon_StatPanel:Hide() -- Hide the stat panel initially based on saved preferences
        end

        -- Unregister the event after it's handled
        self:UnregisterEvent("ADDON_LOADED")
    end
end)