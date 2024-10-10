local addonName, addonTable = ...
local optionsPanelCreated = false -- Prevent duplicate creation

-- Color picker helper function
local function ShowColorPicker(r, g, b, a, changedCallback)
    -- Function to handle color change
    ColorPickerFrame.func = function()
        local newR, newG, newB = ColorPickerFrame:GetColorRGB()
        local newA = a -- Default to the current alpha if opacity isn't used
        if ColorPickerFrame.hasOpacity then
            newA = OpacitySliderFrame and OpacitySliderFrame:GetValue() or a
        end
        changedCallback(newR, newG, newB, newA)
    end

    -- Function to handle color picker cancellation
    ColorPickerFrame.cancelFunc = function()
        local oldR, oldG, oldB, oldA = unpack(ColorPickerFrame.previousValues)
        changedCallback(oldR, oldG, oldB, oldA)
    end

    ColorPickerFrame.swatchFunc = ColorPickerFrame.func

    -- Save the previous values so they can be restored on cancel
    ColorPickerFrame.previousValues = {r, g, b, a}
    ColorPickerFrame.hasOpacity = true -- Ensure opacity is enabled
    ColorPickerFrame.opacity = a or 1

    -- Set color safely
    if ColorPickerFrame.SetColorRGB then
        ColorPickerFrame:SetColorRGB(r or 1, g or 1, b or 1) -- Use default values if any are nil
    else
        print("Warning: ColorPickerFrame does not support SetColorRGB")
    end

    -- Show the color picker
    ColorPickerFrame:Hide() -- Necessary to trigger the OnShow handler
    ColorPickerFrame:Show() -- Show the Color Picker
end

-- Function to create the options panel
function FPSAddon_CreateOptionsPanel(fpsText)
    if optionsPanelCreated then return end -- Prevent duplicate creation
    optionsPanelCreated = true

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
    fontSizeSlider:SetValue(FPSAddonDB.fontSize or 14)
    fontSizeSlider:SetValueStep(1)
    FPSFontSizeSliderText:SetText("Font Size")
    FPSFontSizeSliderLow:SetText("8")
    FPSFontSizeSliderHigh:SetText("32")

    fontSizeSlider:SetScript("OnValueChanged", function(self, value)
        FPSAddonDB.fontSize = value
        if fpsText then
            fpsText:SetFont("Fonts\\FRIZQT__.TTF", value)
        end
    end)

    -- Color picker for FPS text color
    local colorPickerButton = CreateFrame("Button", nil, optionsFrame, "UIPanelButtonTemplate")
    colorPickerButton:SetPoint("TOPLEFT", fontSizeSlider, "BOTTOMLEFT", 0, -20)
    colorPickerButton:SetText("Set Text Color")
    colorPickerButton:SetSize(120, 30)

    colorPickerButton:SetScript("OnClick", function()
        local textColor = FPSAddonDB.textColor or {1, 1, 1, 1}
        ShowColorPicker(textColor[1], textColor[2], textColor[3], textColor[4], function(newR, newG, newB, newA)
            FPSAddonDB.textColor = {newR, newG, newB, newA}
            if addonTable.fpsText then
                addonTable.fpsText:SetTextColor(newR, newG, newB, newA)
            end
        end)
    end)

    -- Show/Hide Stats Panel Checkbox
    local showStatsCheckbox = CreateFrame("CheckButton", "FPSAddonShowStatsCheckbox", optionsFrame, "InterfaceOptionsCheckButtonTemplate")
    showStatsCheckbox:SetPoint("TOPLEFT", colorPickerButton, "BOTTOMLEFT", 0, -20)
    showStatsCheckbox.Text:SetText("Show Stats Panel")
    showStatsCheckbox:SetChecked(FPSAddonDB.showStatPanel)

    showStatsCheckbox:SetScript("OnClick", function(self)
        FPSAddonDB.showStatPanel = self:GetChecked()
        FPSAddon_UpdateStatPanelVisibility()
    end)

    -- Show/Hide FPS Checkbox
    local showFPSCheckbox = CreateFrame("CheckButton", "FPSAddonShowFPSCheckbox", optionsFrame, "InterfaceOptionsCheckButtonTemplate")
    showFPSCheckbox:SetPoint("TOPLEFT", showStatsCheckbox, "BOTTOMLEFT", 0, -10)
    showFPSCheckbox.Text:SetText("Show FPS")
    showFPSCheckbox:SetChecked(FPSAddonDB.showFPS)

    showFPSCheckbox:SetScript("OnClick", function(self)
        FPSAddonDB.showFPS = self:GetChecked()
        if addonTable.fpsText then
            if FPSAddonDB.showFPS then
                addonTable.fpsText:Show()
            else
                addonTable.fpsText:Hide()
            end
        end
    end)

    -- Register the options panel in the interface options
    if Settings and Settings.RegisterCanvasLayoutCategory then
        local category = Settings.RegisterCanvasLayoutCategory(optionsFrame, addonName)
        Settings.RegisterAddOnCategory(category)
    else
        if InterfaceOptions_AddCategory then
            InterfaceOptions_AddCategory(optionsFrame)
        else
            print("Error: Interface options API is not available.")
        end
    end
end