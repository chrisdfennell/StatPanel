local addonName, addonTable = ...
local optionsPanelCreated = false -- Prevent duplicate creation

-- Function to update Stat Panel visibility
function SPAddon_UpdateStatPanelVisibility()
    if SPAddonDB.showStatPanel and SPAddon_StatPanel then
        SPAddon_StatPanel:Show()
    elseif SPAddon_StatPanel then
        SPAddon_StatPanel:Hide()
    end
end

-- Function to refresh the FPS text color
local function RefreshFPSTextColor()
    local textColor = SPAddonDB.textColor or {1, 1, 1, 1}
    if addonTable.fpsText then
        addonTable.fpsText:SetTextColor(textColor[1], textColor[2], textColor[3], textColor[4])
    end
end

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
function SPAddon_CreateOptionsPanel(fpsText)
    if optionsPanelCreated then return end -- Prevent duplicate creation
    optionsPanelCreated = true

    -- Create the main options panel frame
    local optionsFrame = CreateFrame("Frame", "SPAddonOptions", InterfaceOptionsFramePanelContainer)
    optionsFrame.name = "StatPanel"

    -- Add a title to the options panel
    local title = optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText(addonName)

    -- Color picker for FPS text color
    local colorPickerButton = CreateFrame("Button", nil, optionsFrame, "UIPanelButtonTemplate")
    colorPickerButton:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -20)
    colorPickerButton:SetText("Set FPS Text Color")
    colorPickerButton:SetSize(120, 30)

    colorPickerButton:SetScript("OnClick", function()
        local textColor = SPAddonDB.textColor or {1, 1, 1, 1}
        ShowColorPicker(textColor[1], textColor[2], textColor[3], textColor[4], function(newR, newG, newB, newA)
            -- Update the saved color value
            SPAddonDB.textColor = {newR, newG, newB, newA}
            
            -- Immediately apply the color change to the FPS text
            if addonTable.fpsText then
                addonTable.fpsText:SetTextColor(newR, newG, newB, newA)
                
                -- Forcefully refresh by detaching and reattaching the text to the frame
                local parentFrame = addonTable.fpsText:GetParent()
                if parentFrame then
                    addonTable.fpsText:ClearAllPoints()
                    addonTable.fpsText:SetPoint("CENTER", parentFrame, "CENTER")
                end
            end
        end)
    end)

    -- Show/Hide Stats Panel Checkbox
    local showStatsCheckbox = CreateFrame("CheckButton", "SPAddonShowStatsCheckbox", optionsFrame, "InterfaceOptionsCheckButtonTemplate")
    showStatsCheckbox:SetPoint("TOPLEFT", colorPickerButton, "BOTTOMLEFT", 0, -20)
    showStatsCheckbox.Text:SetText("Show Stats Panel")
    showStatsCheckbox:SetChecked(SPAddonDB.showStatPanel)

    showStatsCheckbox:SetScript("OnClick", function(self)
        SPAddonDB.showStatPanel = self:GetChecked()
        SPAddon_UpdateStatPanelVisibility()
    end)

    -- Show/Hide FPS Checkbox
    local showFPSCheckbox = CreateFrame("CheckButton", "SPAddonShowFPSCheckbox", optionsFrame, "InterfaceOptionsCheckButtonTemplate")
    showFPSCheckbox:SetPoint("TOPLEFT", showStatsCheckbox, "BOTTOMLEFT", 0, -10)
    showFPSCheckbox.Text:SetText("Show FPS")
    showFPSCheckbox:SetChecked(SPAddonDB.showFPS)

    showFPSCheckbox:SetScript("OnClick", function(self)
        SPAddonDB.showFPS = self:GetChecked()
        if addonTable.fpsText then
            if SPAddonDB.showFPS then
                addonTable.fpsText:Show()
            else
                addonTable.fpsText:Hide()
            end
        end
    end)

    -- Hide in Combat Checkbox
    local hideInCombatCheckbox = CreateFrame("CheckButton", "SPAddonHideInCombatCheckbox", optionsFrame, "InterfaceOptionsCheckButtonTemplate")
    hideInCombatCheckbox:SetPoint("TOPLEFT", showFPSCheckbox, "BOTTOMLEFT", 0, -10)
    hideInCombatCheckbox.Text:SetText("Hide Panel in Combat")
    hideInCombatCheckbox:SetChecked(SPAddonDB.hideInCombat)

    hideInCombatCheckbox:SetScript("OnClick", function(self)
        SPAddonDB.hideInCombat = self:GetChecked()
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