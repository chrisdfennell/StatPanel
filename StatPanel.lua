-- StatPanel.lua (Handles stat panel display based on options)

local addonName, addonTable = ...
local _, NS = ...

-- Utility functions for speed calculation and dragonriding detection
NS.GetSpeedInfo = function()
    return GetUnitSpeed("player")
end

NS.IsDragonriding = function()
    return UnitPowerBarID("player") == 631
end

local sessionStartTime = GetTime()

-- Declare the StatPanel function globally to avoid nil value errors
CreateStatPanel = function()
    if SPAddon_StatPanel then
        return SPAddon_StatPanel -- If already created, return the existing frame
    end

    local statFrame = CreateFrame("Frame", "StatPanelFrame", UIParent)
    statFrame:SetSize(180, 350) -- Adjusted size to reduce blank space
    statFrame:SetPoint("CENTER", UIParent, "CENTER", 300, 0) -- Position on the screen
    statFrame:SetMovable(true)
    statFrame:EnableMouse(true)
    statFrame:RegisterForDrag("LeftButton")
    statFrame:SetScript("OnDragStart", statFrame.StartMoving)
    statFrame:SetScript("OnDragStop", statFrame.StopMovingOrSizing)

    -- Create a nice background with some transparency
    statFrame.bg = statFrame:CreateTexture(nil, "BACKGROUND")
    statFrame.bg:SetAllPoints(statFrame)
    statFrame.bg:SetColorTexture(0, 0, 0, 0.6) -- Semi-transparent black

    -- Add a border around the frame
    statFrame.border = CreateFrame("Frame", nil, statFrame, "BackdropTemplate")
    statFrame.border:SetAllPoints(statFrame)
    statFrame.border:SetBackdrop({
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 16,
    })
    statFrame.border:SetBackdropBorderColor(1, 1, 1, 0.8) -- White border

    -- Add a title for iLvl
    statFrame.title = statFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    statFrame.title:SetPoint("TOP", statFrame, "TOP", 0, -10)
    statFrame.title:SetTextColor(1, 0.85, 0) -- Gold color for the title
    statFrame.title:SetText("iLvl: 000") -- Placeholder, updated dynamically

    -- Check if SPAddonDB is loaded properly
    if not SPAddonDB then
        print("Error: SPAddonDB is not initialized.")
        return statFrame -- Return the empty frame if DB is not initialized
    end

    -- Create sections and bars for each stat
    local sections = {
        {title = "Enhancements", key = "showEnhancements", stats = {
            {name = "Crit", color = {1, 0, 0}},        -- Red for Crit
            {name = "Haste", color = {1, 1, 0}},       -- Yellow for Haste
            {name = "Mastery", color = {0, 1, 0}},     -- Green for Mastery
            {name = "Versatility", color = {0, 0, 1}}, -- Blue for Versatility
        }},
        {title = "Defense", key = "showDefense", stats = {
            {name = "Armor", color = {0.5, 0.5, 0.5}}, -- Gray for Armor
            {name = "Dodge", color = {1, 0.5, 0}},     -- Orange for Dodge
        }},
        {title = "Supplementary", key = "showSupplementary", stats = {
            {name = "Leech", color = {0.58, 0, 0.83}}, -- Purple for Leech
            {name = "Avoidance", color = {0, 1, 1}},   -- Cyan for Avoidance
            {name = "Speed", color = {1, 0.75, 0.25}}, -- Orange-Yellow for Speed
        }},
    }

    local sectionFrames = {}
    local statText = {}
    local statBars = {}

    -- Helper function to create bars
    local function CreateBar(statFrame, yOffset, statName, statColor)
        -- Create a bar for each stat
        local bar = CreateFrame("StatusBar", nil, statFrame)
        bar:SetSize(150, 16) -- Adjusted size to dynamically fill the frame
        bar:SetPoint("TOP", statFrame, "TOP", 0, yOffset)
        bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
        bar:SetStatusBarColor(unpack(statColor)) -- Set the color

        -- Create a label for the stat text
        local statLabel = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        statLabel:SetPoint("CENTER", bar, "CENTER", 0, 0) -- Center the text in the bar

        -- Bar background
        local bg = bar:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints(true)
        bg:SetColorTexture(0, 0, 0, 0.5) -- Dark background for the bar

        -- Assign the created bar and label to the tables
        statBars[statName] = bar
        statText[statName] = statLabel

        return yOffset - 25
    end

    -- Create sections
    local function CreateBarsForSection(section, yOffset)
        -- Check if the section should be shown
        if not SPAddonDB[section.key] then
            return yOffset
        end

        -- Section Title
        local sectionFrame = statFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        sectionFrame:SetPoint("TOP", statFrame, "TOP", 0, yOffset)
        sectionFrame:SetText(section.title)
        sectionFrame:SetTextColor(0.8, 0.8, 0.8) -- Light gray
        table.insert(sectionFrames, sectionFrame)
        yOffset = yOffset - 20

        for _, stat in ipairs(section.stats) do
            yOffset = CreateBar(statFrame, yOffset, stat.name, stat.color)
        end

        return yOffset
    end

    local yOffset = -40
    for _, section in ipairs(sections) do
        yOffset = CreateBarsForSection(section, yOffset)
    end

    -- Add FPS display
    local fpsText = statFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    fpsText:SetPoint("BOTTOM", statFrame, "BOTTOM", 0, 10) -- Adjusted to remove extra space
    fpsText:SetFont("Fonts\\FRIZQT__.TTF", SPAddonDB.fontSize or 14)

    -- Ensure that the color values are set or use defaults
    local textColor = SPAddonDB.textColor or {1, 1, 1, 1}
    fpsText:SetTextColor(textColor[1] or 1, textColor[2] or 1, textColor[3] or 1, textColor[4] or 1)
    statFrame.fpsText = fpsText -- Store reference to fpsText for updates

    -- Update Stats Function
    local lastUpdate = 0
    local function UpdateStats(self, elapsed)
        lastUpdate = lastUpdate + elapsed
        if lastUpdate < 0.1 then
            return
        end
        lastUpdate = 0

        if not statFrame:IsShown() then return end

        -- Get the player's item level
        local avgItemLevel, avgItemLevelEquipped = GetAverageItemLevel()
        statFrame.title:SetText(string.format("iLvl: %.2f", avgItemLevelEquipped))

        -- Retrieve stat values
        local crit = GetCombatRatingBonus(CR_CRIT_MELEE)
        local haste = GetCombatRatingBonus(CR_HASTE_MELEE)
        local mastery = GetMasteryEffect()
        local versatility = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE)
        local armor = select(2, UnitArmor("player")) -- Get effective armor value
        local playerLevel = UnitLevel("player")
        local damageReductionEvenlyMatched
        local damageReductionCurrentTarget

        -- Calculate damage reduction against an evenly matched enemy
        if playerLevel < 60 then
            damageReductionEvenlyMatched = 100 - (armor / ((85 * playerLevel) + armor + 400)) * 100
        else
            damageReductionEvenlyMatched = math.floor((armor / (armor + 114808.1)) * 100 + 0.5) -- Reverse-engineered for level 80
        end

        -- Calculate damage reduction against the current target
        if UnitExists("target") then
            local targetLevel = UnitLevel("target") or -1
            local maxPlayerLevel = GetMaxPlayerLevel()
            if UnitClassification("target") == "worldboss" or targetLevel == -1 or targetLevel > playerLevel + 2 then
                -- For bosses or higher-level targets (e.g., level 83 raid boss)
                damageReductionCurrentTarget = math.floor((armor / (armor + 106634.5)) * 100 + 0.5) -- Adjusted for boss-level target
            -- If the target is not a world boss or significantly higher-level, use the standard calculation for that specific target level
            else
                damageReductionCurrentTarget = math.floor((armor / (armor + 114808.1)) * 100 + 0.5) -- Consistent with evenly matched scenario for non-boss targets
            end
        else
            -- If no target, use evenly matched calculation
            damageReductionCurrentTarget = damageReductionEvenlyMatched
        end

        local dodge = GetDodgeChance()
        local leech = GetLifesteal() -- Updated leech calculation to use correct API
        local avoidance = GetAvoidance()

        -- Get Speed Info
        local baseSpeed, runSpeed, flightSpeed = GetUnitSpeed("player")
        local speed = 0

        -- Determine speed value
        if IsPlayerMoving() then
            if NS.IsDragonriding() then
                local isGliding, canGlide, forwardSpeed = C_PlayerInfo.GetGlidingInfo()
                if isGliding then
                    speed = forwardSpeed / BASE_MOVEMENT_SPEED * 100
                else
                    speed = flightSpeed / BASE_MOVEMENT_SPEED * 100
                    if not IsFlying() then
                        speed = speed / 2 -- Halve the speed when on the ground with a dragonriding mount
                    end
                end
            elseif IsFlying() then
                speed = flightSpeed / BASE_MOVEMENT_SPEED * 100
            else
                speed = runSpeed / BASE_MOVEMENT_SPEED * 100
            end
        else
            speed = 0 -- Set speed to 0 when the player is not moving
        end

        -- Adjust speed for backwards movement
        if GetUnitSpeed("player") < 0 then
            speed = 64
        end

        -- Update stat bars
        if statText["Crit"] then
            statText["Crit"]:SetText(string.format("Crit: %.2f%%", crit))
            statBars["Crit"]:SetMinMaxValues(0, 100)
            statBars["Crit"]:SetValue(crit)
        end
        if statText["Haste"] then
            statText["Haste"]:SetText(string.format("Haste: %.2f%%", haste))
            statBars["Haste"]:SetMinMaxValues(0, 100)
            statBars["Haste"]:SetValue(haste)
        end
        if statText["Mastery"] then
            statText["Mastery"]:SetText(string.format("Mastery: %.2f%%", mastery))
            statBars["Mastery"]:SetMinMaxValues(0, 100)
            statBars["Mastery"]:SetValue(mastery)
        end
        if statText["Versatility"] then
            statText["Versatility"]:SetText(string.format("Versatility: %.2f%%", versatility))
            statBars["Versatility"]:SetMinMaxValues(0, 100)
            statBars["Versatility"]:SetValue(versatility)
        end
        if statText["Armor"] then
            statText["Armor"]:SetText(string.format("Damage Reduction: %d%%", damageReductionCurrentTarget))
            statBars["Armor"]:SetMinMaxValues(0, 100)
            statBars["Armor"]:SetValue(damageReductionCurrentTarget)
        end
        if statText["Dodge"] then
            statText["Dodge"]:SetText(string.format("Dodge: %.2f%%", dodge))
            statBars["Dodge"]:SetMinMaxValues(0, 100)
            statBars["Dodge"]:SetValue(dodge)
        end
        if statText["Leech"] then
            statText["Leech"]:SetText(string.format("Leech: %.2f%%", leech))
            statBars["Leech"]:SetMinMaxValues(0, 100)
            statBars["Leech"]:SetValue(leech)
        end
        if statText["Avoidance"] then
            statText["Avoidance"]:SetText(string.format("Avoidance: %.2f%%", avoidance))
            statBars["Avoidance"]:SetMinMaxValues(0, 100)
            statBars["Avoidance"]:SetValue(avoidance)
        end
        if statText["Speed"] then
            -- Update speed value dynamically with a progress bar
            statText["Speed"]:SetText(string.format("Speed: %.2f%%", speed))
            statBars["Speed"]:SetMinMaxValues(0, 1500) -- Set max value to 1500%
            statBars["Speed"]:SetValue(speed)
        end

        -- Update FPS
        if SPAddonDB.showFPS then
            local fps = GetFramerate()
            fpsText:SetText(string.format("FPS: %.1f", fps))
            fpsText:Show()
        else
            fpsText:Hide()
        end
    end

    -- Set OnUpdate script to continuously update stats
    statFrame:SetScript("OnUpdate", function(self, elapsed)
        UpdateStats(self, elapsed)
    end)

    -- Initial update
    UpdateStats(statFrame, 0)

    SPAddon_StatPanel = statFrame
    return statFrame
end

function ToggleStatPanel()
    -- Check if the stat panel has been created, create if not
    if not SPAddon_StatPanel then
        SPAddon_StatPanel = CreateStatPanel()
    end

    -- Ensure it's toggled based on the database setting
    if SPAddonDB.showStatPanel then
        SPAddon_StatPanel:Show()
    else
        SPAddon_StatPanel:Hide()
    end
end

-- Initialize the stat panel after ADDON_LOADED
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, arg1)
    if arg1 == addonName then
        -- Ensure the panel is created only once on ADDON_LOADED
        if not SPAddon_StatPanel and SPAddonDB.showStatPanel then
            ToggleStatPanel()
        end
    end
end)