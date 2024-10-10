local addonName, addonTable = ...
local sessionStartTime = GetTime()

-- Function to initialize the FPS frame
function FPSAddon_InitializeFPSFrame()
    local fpsFrame = CreateFrame("Frame", "FPSFrame", UIParent)
    fpsFrame:SetSize(200, 50)
    fpsFrame:SetPoint("TOP", UIParent, "TOP", 0, -10)
    fpsFrame:SetMovable(true)
    fpsFrame:EnableMouse(true)
    fpsFrame:RegisterForDrag("LeftButton")
    fpsFrame:SetScript("OnDragStart", fpsFrame.StartMoving)
    fpsFrame:SetScript("OnDragStop", fpsFrame.StopMovingOrSizing)

    -- Create the text element for displaying FPS
    local fpsText = fpsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    fpsText:SetPoint("CENTER", fpsFrame, "CENTER")
    fpsText:SetFont("Fonts\\FRIZQT__.TTF", FPSAddonDB.fontSize or 14)

    -- Ensure that the color values are set or use defaults
    local textColor = FPSAddonDB.textColor or {1, 1, 1, 1}
    fpsText:SetTextColor(textColor[1] or 1, textColor[2] or 1, textColor[3] or 1, textColor[4] or 1)

    fpsFrame.fpsText = fpsText -- Store reference to fpsText for updates

    -- Update function
    local function UpdateFPS()
        if FPSAddonDB.showFPS then
            local fps = GetFramerate()
            fpsText:SetText(string.format("FPS: %.1f", fps))
            fpsText:Show()
        else
            fpsText:Hide()
        end
    end

    -- Detect Shift-Left-Click to open options panel
    fpsFrame:SetScript("OnMouseDown", function(self, button)
        if IsShiftKeyDown() and button == "LeftButton" then
            -- Open options panel for Retail WoW
            if Settings and Settings.OpenToCategory then
                Settings.OpenToCategory(addonName)
            elseif InterfaceOptionsFrame_OpenToCategory then
                InterfaceOptionsFrame_OpenToCategory(addonName)
                InterfaceOptionsFrame_OpenToCategory(addonName) -- Called twice to ensure correct tab
            else
                print("Error: Unable to open options panel.")
            end
        end
    end)

    -- Set up the OnUpdate script to refresh FPS
    fpsFrame:SetScript("OnUpdate", function(self, elapsed)
        UpdateFPS()
    end)

    -- Assign fpsText to addonTable for reference in options
    addonTable.fpsText = fpsText

    -- Add mouseover event to show performance stats
    fpsFrame:SetScript("OnEnter", function()
        ShowPerformanceStats(fpsText)
    end)
    fpsFrame:SetScript("OnLeave", HidePerformanceStats)
end

-- Function to show performance stats (ping, memory, etc.) on mouseover
function ShowPerformanceStats(fpsText)
    if not FPSAddonDB.showStatPanel then return end -- Don't show if Stat Panel is disabled

    if not performanceStatsFrame then
        performanceStatsFrame = CreateFrame("Frame", "PerformanceStatsFrame", UIParent, "TooltipBorderedFrameTemplate")
        performanceStatsFrame:SetSize(300, 150)
        performanceStatsFrame:SetPoint("TOP", fpsText, "BOTTOM", 0, -5)

        performanceStatsFrame.text = performanceStatsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        performanceStatsFrame.text:SetPoint("CENTER", performanceStatsFrame, "CENTER", 0, 0)
    end

    local _, _, latencyHome, latencyWorld = GetNetStats()
    local totalMemory = gcinfo() / 1024 -- Total memory in MB
    UpdateAddOnMemoryUsage()

    local addonCountText = ""
    if GetNumAddOns then
        local totalAddOns = GetNumAddOns()
        addonCountText = string.format("Addon Count: %d\n", totalAddOns)
    end

    local sessionDuration = GetTime() - sessionStartTime
    local hours = floor(sessionDuration / 3600)
    local minutes = floor((sessionDuration % 3600) / 60)
    local seconds = floor(sessionDuration % 60)

    performanceStatsFrame.text:SetText(string.format(
        "Ping: %d ms(H), %d ms(W)\nTotal Memory: %.2f MB\n%sSession Time: %02d:%02d:%02d",
        latencyHome, latencyWorld, totalMemory, addonCountText, hours, minutes, seconds
    ))

    performanceStatsFrame:Show()
end

-- Function to hide performance stats window
function HidePerformanceStats()
    if performanceStatsFrame then
        performanceStatsFrame:Hide()
    end
end

-- Function to update Stat Panel visibility
function FPSAddon_UpdateStatPanelVisibility()
    if FPSAddonDB.showStatPanel and FPSAddon_StatPanel then
        FPSAddon_StatPanel:Show()
    elseif FPSAddon_StatPanel then
        FPSAddon_StatPanel:Hide()
    end
end