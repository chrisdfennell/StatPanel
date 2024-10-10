local addonName, addonTable = ...
local eventFrame = CreateFrame("Frame")

-- Register ADDON_LOADED event
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, arg1)
    if arg1 == addonName then
        -- Initialize FPSAddonDB if it's nil
        if not FPSAddonDB then
            FPSAddonDB = {
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
        FPSAddon_InitializeFPSFrame()

        if FPSAddon_CreateOptionsPanel then
            FPSAddon_CreateOptionsPanel() -- Ensure the function exists before calling it
        else
            print("Error: FPSAddon_CreateOptionsPanel is not defined.")
        end

        -- Create StatPanel after ensuring the saved variables are loaded
        FPSAddon_StatPanel = CreateStatPanel()
        if not FPSAddonDB.showStatPanel then
            FPSAddon_StatPanel:Hide() -- Hide the stat panel initially based on saved preferences
        end

        -- Unregister the event after it's handled
        self:UnregisterEvent("ADDON_LOADED")
    end
end)
