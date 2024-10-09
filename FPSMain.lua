local addonName, addonTable = ...

-- Create the event frame
local eventFrame = CreateFrame("Frame")

-- Register ADDON_LOADED event
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, arg1)
    if arg1 == addonName then
        -- Call the functions from the other files
        FPSAddon_InitializeFPSFrame()
        FPSAddon_CreateOptionsPanel()
        self:UnregisterEvent("ADDON_LOADED") -- Unregister after it's handled
    end
end)