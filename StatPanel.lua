-- StatPanel.lua
-- Module to display player stats with iLvl and colored bars

-- Declare the StatPanel function globally to avoid nil value errors
    CreateStatPanel = function()
        -- Create the main frame for the stat panel
        local statFrame = CreateFrame("Frame", "StatPanelFrame", UIParent)
        statFrame:SetSize(180, 350) -- Set the frame size to accommodate the bars
        statFrame:SetPoint("CENTER", UIParent, "CENTER", 300, 0) -- Position the frame on the screen
        statFrame:SetMovable(true)
        statFrame:EnableMouse(true)
        statFrame:RegisterForDrag("LeftButton")
        statFrame:SetScript("OnDragStart", statFrame.StartMoving)
        statFrame:SetScript("OnDragStop", statFrame.StopMovingOrSizing)
    
        -- Create a semi-transparent black background for the frame
        statFrame.bg = statFrame:CreateTexture(nil, "BACKGROUND")
        statFrame.bg:SetAllPoints(statFrame)
        statFrame.bg:SetColorTexture(0, 0, 0, 0.6)
    
        -- Add a white border around the frame
        statFrame.border = CreateFrame("Frame", nil, statFrame, "BackdropTemplate")
        statFrame.border:SetAllPoints(statFrame)
        statFrame.border:SetBackdrop({
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 16,
        })
        statFrame.border:SetBackdropBorderColor(1, 1, 1, 0.8)
    
        -- Add a title for the item level (iLvl)
        statFrame.title = statFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        statFrame.title:SetPoint("TOP", statFrame, "TOP", 0, -10)
        statFrame.title:SetTextColor(1, 0.85, 0) -- Gold color for the title
        statFrame.title:SetText("iLvl: 000") -- Placeholder, updated dynamically
    
        -- Check if FPSAddonDB is loaded properly
        if not FPSAddonDB then
            print("Error: FPSAddonDB is not initialized.")
            return statFrame -- Return the empty frame if the database is not initialized
        end
    
        -- Define sections for stats, each with a title and associated stats
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
            }},
        }
    
        local sectionFrames = {}
        local statText = {}
        local statBars = {}
    
        -- Helper function to create a bar for each stat
        local function CreateBar(statFrame, yOffset, statName, statColor)
            -- Create a status bar for the stat
            local bar = CreateFrame("StatusBar", nil, statFrame)
            bar:SetSize(150, 16) -- Set the size of the bar
            bar:SetPoint("TOP", statFrame, "TOP", 0, yOffset) -- Position the bar
            bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
            bar:SetStatusBarColor(unpack(statColor)) -- Set the bar color
    
            -- Create a label for the stat text, centered in the bar
            local statLabel = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            statLabel:SetPoint("CENTER", bar, "CENTER", 0, 0)
    
            -- Create a dark background for the bar
            local bg = bar:CreateTexture(nil, "BACKGROUND")
            bg:SetAllPoints(true)
            bg:SetColorTexture(0, 0, 0, 0.5)
    
            -- Store references to the bar and label for later updates
            statBars[statName] = bar
            statText[statName] = statLabel
    
            return yOffset - 25 -- Adjust yOffset for the next bar
        end
    
        -- Function to create bars for each section
        local function CreateBarsForSection(section, yOffset)
            -- Check if the section should be shown based on settings
            if not FPSAddonDB[section.key] then
                return yOffset
            end
    
            -- Create a title for the section
            local sectionFrame = statFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            sectionFrame:SetPoint("TOP", statFrame, "TOP", 0, yOffset)
            sectionFrame:SetText(section.title)
            sectionFrame:SetTextColor(0.8, 0.8, 0.8) -- Light gray color for section titles
            table.insert(sectionFrames, sectionFrame)
            yOffset = yOffset - 20 -- Adjust yOffset for the section title
    
            -- Create bars for each stat in the section
            for _, stat in ipairs(section.stats) do
                yOffset = CreateBar(statFrame, yOffset, stat.name, stat.color)
            end
    
            return yOffset
        end
    
        local yOffset = -40 -- Initial offset for placing elements
        for _, section in ipairs(sections) do
            yOffset = CreateBarsForSection(section, yOffset) -- Create each section
        end
    
        -- Function to update stats dynamically
        local function UpdateStats()
            -- Only update if the stat frame is currently shown
            if not statFrame:IsShown() then return end
    
            -- Get the average item level and update the title
            local avgItemLevel, avgItemLevelEquipped = GetAverageItemLevel()
            statFrame.title:SetText(string.format("iLvl: %.2f", avgItemLevelEquipped))
    
            -- Get various player stats
            local crit = GetCombatRatingBonus(CR_CRIT_MELEE)
            local haste = GetCombatRatingBonus(CR_HASTE_MELEE)
            local mastery = GetMasteryEffect()
            local versatility = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE)
            local dodge = GetDodgeChance()
            local leech = GetCombatRatingBonus(CR_LIFESTEAL)
            local avoidance = GetAvoidance()
    
            -- Update the stat text and bar values for each stat
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
                -- Get the effective armor value and calculate damage reduction
                local _, effectiveArmor = UnitArmor("player")
                local playerLevel = UnitLevel("player")
                local attackerLevel = playerLevel -- Assuming evenly matched level target
    
                -- Formula for calculating physical damage reduction
                local damageReduction = (effectiveArmor / (effectiveArmor + (467.5 * attackerLevel - 22167.5))) * 100
    
                -- Update the stat text and bar for armor
                statText["Armor"]:SetText(string.format("Damage Reduction: %.2f%%", damageReduction))
                statBars["Armor"]:SetMinMaxValues(0, 100)
                statBars["Armor"]:SetValue(damageReduction)
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
        end
    
        -- Register events to update stats when relevant events occur
        statFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
        statFrame:RegisterEvent("UNIT_STATS")
        statFrame:RegisterEvent("COMBAT_RATING_UPDATE")
        statFrame:SetScript("OnEvent", UpdateStats)
    
        -- Perform an initial update of the stats
        UpdateStats()
    
        -- Return the stat frame
        return statFrame
    end
    
    -- Initialize the stat panel after the addon is loaded
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("ADDON_LOADED")
    eventFrame:SetScript("OnEvent", function(self, event, arg1)
        if arg1 == addonName and FPSAddonDB and FPSAddonDB.showStatPanel then
            if not FPSAddon_StatPanel then
                FPSAddon_StatPanel = CreateStatPanel()
            end
        end
    end)
    