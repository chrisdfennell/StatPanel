local addonName, addonTable = ...
local optionsPanelCreated = false

-- Function to create the options panel
function FPSAddon_CreateOptionsPanel(fpsText)
    if optionsPanelCreated then return end
    optionsPanelCreated = true

    -- Ensure updateInterval is properly initialized
    if not FPSAddonDB.updateInterval or type(FPSAddonDB.updateInterval) ~= "number" then
        FPSAddonDB.updateInterval = 0.5 -- Fallback to default 0.5 seconds
    end

    -- Create the main options panel frame
    local optionsFrame = CreateFrame("Frame", "FPSAddonOptions", InterfaceOptionsFramePanelContainer)
    optionsFrame.name = addonName

    -- Add a title to the options panel
    local title = optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText(addonName)

    -- Font size slider
    local fontSizeSlider = CreateFrame("Slider", "FPSFontSizeSlider", optionsFrame, "OptionsSliderTemplate")
    fontSizeSlider:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -40)
    fontSizeSlider:SetMinMaxValues(8, 32)
    fontSizeSlider:SetValue(FPSAddonDB.fontSize)
    fontSizeSlider:SetValueStep(1)
    fontSizeSlider:SetObeyStepOnDrag(true)

    -- Font size slider labels
    local FPSFontSizeSliderText = fontSizeSlider:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    FPSFontSizeSliderText:SetPoint("TOP", fontSizeSlider, "BOTTOM", 0, -5)
    FPSFontSizeSliderText:SetText("Font Size")

    fontSizeSlider:SetScript("OnValueChanged", function(self, value)
        FPSAddonDB.fontSize = value
        fpsText:SetFont("Fonts\\FRIZQT__.TTF", value)
    end)

    -- Checkbox for FPS display toggle
    local showFPSToggle = CreateFrame("CheckButton", nil, optionsFrame, "UICheckButtonTemplate")
    showFPSToggle:SetPoint("TOPLEFT", fontSizeSlider, "BOTTOMLEFT", 0, -30)
    showFPSToggle.text:SetText("Show FPS")
    showFPSToggle:SetChecked(FPSAddonDB.showFPS)

    showFPSToggle:SetScript("OnClick", function(self)
        FPSAddonDB.showFPS = self:GetChecked()
        UpdateText()
    end)

    -- Checkbox for Home Latency display toggle
    local showHomeLatencyToggle = CreateFrame("CheckButton", nil, optionsFrame, "UICheckButtonTemplate")
    showHomeLatencyToggle:SetPoint("TOPLEFT", showFPSToggle, "BOTTOMLEFT", 0, -20)
    showHomeLatencyToggle.text:SetText("Show Home Latency")
    showHomeLatencyToggle:SetChecked(FPSAddonDB.showHomeLatency)

    showHomeLatencyToggle:SetScript("OnClick", function(self)
        FPSAddonDB.showHomeLatency = self:GetChecked()
        UpdateText()
    end)

    -- Checkbox for World Latency display toggle
    local showWorldLatencyToggle = CreateFrame("CheckButton", nil, optionsFrame, "UICheckButtonTemplate")
    showWorldLatencyToggle:SetPoint("TOPLEFT", showHomeLatencyToggle, "BOTTOMLEFT", 0, -20)
    showWorldLatencyToggle.text:SetText("Show World Latency")
    showWorldLatencyToggle:SetChecked(FPSAddonDB.showWorldLatency)

    showWorldLatencyToggle:SetScript("OnClick", function(self)
        FPSAddonDB.showWorldLatency = self:GetChecked()
        UpdateText()
    end)

    -- Register the options panel in the interface options
    if Settings and type(addonName) == "string" then
        -- For Retail WoW
        local category = Settings.RegisterCanvasLayoutCategory(optionsFrame, addonName)
        Settings.RegisterAddOnCategory(category) -- Explicitly register the category
    elseif InterfaceOptions_AddCategory and type(addonName) == "string" then
        -- For Classic WoW
        InterfaceOptions_AddCategory(optionsFrame)
    else
        print("Error: Invalid addonName or WoW version mismatch.")
    end
end