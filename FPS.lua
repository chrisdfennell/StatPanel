-- Create a SavedVariables table for the addon's settings
FPSAddonDB = FPSAddonDB or {
    point = "CENTER",
    relativePoint = "CENTER",
    xOfs = 0,
    yOfs = 0,
    fontSize = 14,
    textColor = {r = 1, g = 1, b = 1, a = 1},
    updateInterval = 0.5, -- Default to 0.5 seconds
}

local fpsText
local ticker = nil
local performanceStatsFrame = nil
local sessionStartTime = GetTime()
local statsTicker = nil

-- Function to update FPS display
local function UpdateText()
    if fpsText then
        local fps = floor(GetFramerate())
        fpsText:SetText(string.format("FPS: %d", fps))
    else
        print("Error: fpsText is nil")
    end
end

-- Function to show performance stats (ping, memory, etc.) on mouseover
local function ShowPerformanceStats()
    if not performanceStatsFrame then
        -- Create the performance stats frame if it doesn't exist yet
        performanceStatsFrame = CreateFrame("Frame", "PerformanceStatsFrame", UIParent, "TooltipBorderedFrameTemplate")
        performanceStatsFrame:SetSize(300, 150)
        performanceStatsFrame:SetPoint("TOP", fpsText, "BOTTOM", 0, -5)
        
        performanceStatsFrame.text = performanceStatsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        performanceStatsFrame.text:SetPoint("CENTER", performanceStatsFrame, "CENTER", 0, 0)
    end

    local _, _, latencyHome, latencyWorld = GetNetStats()
    local totalMemory = gcinfo() / 1024 -- Total memory in MB
    UpdateAddOnMemoryUsage()

    -- Addon-specific memory and CPU usage (Retail Only)
    local addonMemory = GetAddOnMemoryUsage("YourAddonNameHere") / 1024 -- Addon-specific memory in MB
    local addonCPUUsage = GetAddOnCPUUsage("YourAddonNameHere") / 1000 -- CPU usage in seconds (Retail Only)

    -- Player coordinates
    local mapID = C_Map.GetBestMapForUnit("player")
    local position = C_Map.GetPlayerMapPosition(mapID, "player")
    local x, y = 0, 0
    if position then
        x, y = position:GetXY()
    end

    -- Player speed
    local speed = GetUnitSpeed("player") / 7 * 100 -- 7 is the base movement speed

    -- Texture quality settings
    local textureQuality = GetCVar("graphicsTextureResolution")

    -- Ping jitter calculation
    local previousPing = FPSAddonDB.previousPing or latencyHome
    local pingJitter = math.abs(latencyHome - previousPing)
    FPSAddonDB.previousPing = latencyHome

    -- Addon count (Retail only, check if function exists)
    local addonCountText = ""
    if GetNumAddOns then
        local totalAddOns = GetNumAddOns()
        addonCountText = string.format("Addon Count: %d\n", totalAddOns)
    end

    -- Session playtime with seconds
    local sessionDuration = GetTime() - sessionStartTime
    local hours = floor(sessionDuration / 3600)
    local minutes = floor((sessionDuration % 3600) / 60)
    local seconds = floor(sessionDuration % 60)

    -- Performance stats text
    performanceStatsFrame.text:SetText(string.format(
        "Ping: %d ms(H), %d ms(W)\nTotal Memory: %.2f MB\nAddon Memory: %.2f MB\nAddon CPU Usage: %.2f s\nPlayer Coords: %.2f, %.2f\nPlayer Speed: %.2f%%\nTexture Quality: %d\nPing Jitter: %d ms\n%sSession Time: %02d:%02d:%02d",
        latencyHome, latencyWorld, totalMemory, addonMemory, addonCPUUsage, x * 100, y * 100, speed, textureQuality, pingJitter, addonCountText, hours, minutes, seconds
    ))

    performanceStatsFrame:Show()
end

-- Function to hide the performance stats window
local function HidePerformanceStats()
    if performanceStatsFrame then
        performanceStatsFrame:Hide()
    end
end

-- Function to start ticker based on update interval
function StartTicker()
    local interval = FPSAddonDB.updateInterval or 0.5

    if ticker then ticker:Cancel() end

    ticker = C_Timer.NewTicker(interval, UpdateText)
end

-- Function to initialize the FPS frame
function FPSAddon_InitializeFPSFrame()
    local fpsFrame = CreateFrame("Frame", "FPSFrame", UIParent)
    fpsFrame:SetSize(150, 50)
    fpsFrame:SetPoint(FPSAddonDB.point, UIParent, FPSAddonDB.relativePoint, FPSAddonDB.xOfs, FPSAddonDB.yOfs)
    fpsFrame:SetMovable(true)
    fpsFrame:EnableMouse(true)
    fpsFrame:RegisterForDrag("LeftButton")
    fpsFrame:SetScript("OnDragStart", fpsFrame.StartMoving)
    fpsFrame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, _, relativePoint, xOfs, yOfs = self:GetPoint()
        FPSAddonDB.point = point
        FPSAddonDB.relativePoint = relativePoint
        FPSAddonDB.xOfs = xOfs
        FPSAddonDB.yOfs = yOfs
    end)

    -- FPS Text
    fpsText = fpsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fpsText:SetPoint("CENTER", fpsFrame, "CENTER")
    fpsText:SetFont("Fonts\\FRIZQT__.TTF", FPSAddonDB.fontSize)
    fpsText:SetTextColor(FPSAddonDB.textColor.r, FPSAddonDB.textColor.g, FPSAddonDB.textColor.b, FPSAddonDB.textColor.a)

    -- Start the ticker for updating FPS display
    StartTicker()

    -- Add mouseover event to show performance stats
    fpsFrame:SetScript("OnEnter", ShowPerformanceStats)
    fpsFrame:SetScript("OnLeave", HidePerformanceStats)

    -- Detect Shift-Left-Click to open the general options menu
    fpsFrame:SetScript("OnMouseDown", function(self, button)
        if IsShiftKeyDown() and button == "LeftButton" then
            -- Open the general options menu
            if InterfaceOptionsFrame then
                InterfaceOptionsFrame:Show() -- Open the general options menu
            else
                print("Error: Unable to open the options menu.")
            end
        end
    end)
end
