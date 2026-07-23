-- Options.lua (Categorized options panel)
--
-- A sidebar of categories on the left, a scrolling page of controls on the
-- right. Pages are built the first time they're opened so login cost stays low.

local addonName, SP = ...
local L = SP.L

local UI = SP.UI
local Config = SP.Config
local Media = SP.Media
local Presets = SP.Presets

local Options = {}
SP.Options = Options

local optionsFrame
local pages = {}          -- [id] = { frame, content, built }
local currentPage

--------------------------------------------------------------------------------
-- SHARED VALUE LISTS
--------------------------------------------------------------------------------
local function mediaValues(kind)
    return function() return Media:List(kind) end
end

local ALIGN_VALUES = {
    { name = L["Left"],   value = "LEFT" },
    { name = L["Center"], value = "CENTER" },
    { name = L["Right"],  value = "RIGHT" },
}

local FILL_VALUES = {
    { name = L["Proportional to value"], value = "value" },
    { name = L["Always full"],           value = "full" },
    { name = L["No fill (text only)"],   value = "none" },
}

local COLOR_MODE_VALUES = {
    { name = L["Per-stat colors"], value = "stat" },
    { name = L["Class color"],     value = "class" },
    { name = L["Single color"],    value = "single" },
    { name = L["Value gradient"],  value = "gradient" },
}

local ROW_STYLE_VALUES = {
    { name = L["Bars"],      value = "bar" },
    { name = L["Text only"], value = "text" },
}

local TITLE_MODE_VALUES = {
    { name = L["Item level"], value = "ilvl" },
    { name = L["Player name"], value = "name" },
    { name = L["Specialization"], value = "spec" },
    { name = L["Custom text"], value = "custom" },
    { name = L["Hidden"], value = "none" },
}

local SOURCE_VALUES = {
    { name = L["Total effect (character sheet)"], value = "total" },
    { name = L["Bonus from rating only"],         value = "bonus" },
}

local function fontFlagValues()
    return Media.fontFlags
end

local function strataValues()
    return Media.strata
end

local function statValues()
    local out = {}
    for _, statName in ipairs(SP.STAT_ORDER) do
        local def = SP.STAT_DEFS[statName]
        out[#out + 1] = { name = def and def.name or statName, value = statName }
    end
    return out
end

--------------------------------------------------------------------------------
-- PAGE: GENERAL
--------------------------------------------------------------------------------
local function buildGeneral(content, stack)
    stack:Add(UI:Header(content, L["Panel"]))

    stack:Add(UI:Check(content, {
        label = L["Enable StatPanel"], path = "enabled",
        tooltip = L["Master switch. Turning this off hides the panel entirely."],
    }))
    stack:Add(UI:Check(content, {
        label = L["Lock position"], path = "panel.locked",
        tooltip = L["Stops the panel from being dragged."],
    }))
    stack:Add(UI:Check(content, {
        label = L["Keep on screen"], path = "panel.clamp",
        tooltip = L["Prevents dragging the panel off the edge of the screen."],
    }))

    stack:Add(UI:Slider(content, {
        label = L["Scale"], path = "panel.scale",
        min = 0.4, max = 3.0, step = 0.05, decimals = 2,
    }))
    stack:Add(UI:Slider(content, {
        label = L["Opacity"], path = "panel.alpha",
        min = 0, max = 1, step = 0.01, decimals = 2,
    }))
    stack:Add(UI:Dropdown(content, {
        label = L["Frame layer"], path = "panel.strata", values = strataValues,
        tooltip = L["Which layer the panel draws on. Raise it if another addon covers the panel."],
    }))
    stack:Add(UI:Slider(content, {
        label = L["Update interval (seconds)"], path = "updateInterval",
        min = 0.02, max = 1.0, step = 0.02, decimals = 2,
        tooltip = L["How often values refresh. Higher values use less CPU."],
    }))
    stack:Add(UI:Dropdown(content, {
        label = L["Stat values show"], path = "valueSource", values = SOURCE_VALUES,
        tooltip = L["Total effect matches the character sheet. Bonus from rating shows only what your gear's rating contributes."],
    }))

    stack:Gap(10)
    stack:Add(UI:Header(content, L["Visibility"]))

    -- Two rules covering opposite states hide the panel everywhere, which reads
    -- as the addon being broken rather than as a setting. Ticking one clears
    -- its opposite; refreshAll makes that visibly untick under the cursor.
    local function clears(opposite)
        return function(value)
            if value then Config:Set(opposite, false) end
        end
    end

    stack:Add(UI:Check(content, {
        label = L["Hide during combat"], path = "panel.hideInCombat",
        onChange = clears("panel.onlyInCombat"), refreshAll = true,
        tooltip = L["Turning this on clears 'Show only during combat'."],
    }))
    stack:Add(UI:Check(content, {
        label = L["Show only during combat"], path = "panel.onlyInCombat",
        onChange = clears("panel.hideInCombat"), refreshAll = true,
        tooltip = L["Turning this on clears 'Hide during combat'."],
    }))
    stack:Add(UI:Check(content, { label = L["Hide while dead"], path = "panel.hideWhenDead" }))
    stack:Add(UI:Check(content, { label = L["Hide in vehicles"], path = "panel.hideInVehicle" }))
    stack:Add(UI:Check(content, { label = L["Hide in pet battles"], path = "panel.hideInPetBattle" }))
    stack:Add(UI:Check(content, {
        label = L["Hide inside instances"], path = "panel.hideInInstance",
        onChange = clears("panel.hideOutOfInstance"), refreshAll = true,
        tooltip = L["Turning this on clears 'Hide outside instances'."],
    }))
    stack:Add(UI:Check(content, {
        label = L["Hide outside instances"], path = "panel.hideOutOfInstance",
        onChange = clears("panel.hideInInstance"), refreshAll = true,
        tooltip = L["Turning this on clears 'Hide inside instances'."],
    }))

    stack:Gap(10)
    stack:Add(UI:Header(content, L["Mouseover fade"]))

    stack:Add(UI:Check(content, {
        label = L["Only show on mouseover"], path = "panel.mouseoverOnly",
        tooltip = L["Fades the panel out until you hover over it."],
    }))
    stack:Add(UI:Slider(content, {
        label = L["Faded opacity"], path = "panel.fadeAlpha",
        min = 0, max = 1, step = 0.01, decimals = 2,
    }))
    stack:Add(UI:Slider(content, {
        label = L["Fade duration (seconds)"], path = "panel.fadeDuration",
        min = 0, max = 2, step = 0.05, decimals = 2,
    }))
    stack:Add(UI:Check(content, { label = L["Show tooltips on hover"], path = "panel.tooltips" }))

    stack:Gap(10)
    stack:Add(UI:Header(content, L["Minimap and options"]))

    -- These two live in the account-wide store rather than the profile, so
    -- switching looks doesn't move your minimap button.
    stack:Add(UI:Check(content, {
        label = L["Show the minimap button"],
        tooltip = L["Left-click opens these options, right-click opens the quick menu. Drag it around the minimap edge."],
        get = function() return not SPAddonDB.global.minimap.hide end,
        set = function(value) SP.Broker:SetHidden(not value) end,
    }))
    stack:Add(UI:Check(content, {
        label = L["Show a live preview while configuring"],
        tooltip = L["Docks the real panel beside this window so you can see changes as you make them."],
        get = function() return SPAddonDB.global.livePreview end,
        set = function(value)
            SPAddonDB.global.livePreview = value
            Options:RefreshPreview()
        end,
    }))

    stack:Gap(10)
    stack:Add(UI:ButtonRow(content, {
        { text = L["Reset position"], width = 130, onClick = function()
            SP.db.panel.pos = Config:DeepCopy(Config.DEFAULTS.panel.pos)
            SP:Refresh()
        end },
        { text = L["Reset peak speed"], width = 130, onClick = function()
            SP.ResetPeakSpeed()
        end },
    }))
end

--------------------------------------------------------------------------------
-- PAGE: PANEL
--------------------------------------------------------------------------------
local function buildPanel(content, stack)
    stack:Add(UI:Header(content, L["Size"]))

    stack:Add(UI:Check(content, {
        label = L["Auto-size width to content"], path = "panel.autoWidth",
        tooltip = L["Grows and shrinks the panel to fit the widest row."],
    }))
    stack:Add(UI:Slider(content, {
        label = L["Width"], path = "panel.width", min = 80, max = 600, step = 1,
    }))
    stack:Add(UI:Slider(content, {
        label = L["Minimum width (auto-size)"], path = "panel.minWidth", min = 60, max = 400, step = 1,
    }))
    stack:Add(UI:Slider(content, {
        label = L["Side padding"], path = "panel.paddingX", min = 0, max = 40, step = 1,
    }))
    stack:Add(UI:Slider(content, {
        label = L["Top padding"], path = "panel.paddingTop", min = 0, max = 40, step = 1,
    }))
    stack:Add(UI:Slider(content, {
        label = L["Bottom padding"], path = "panel.paddingBottom", min = 0, max = 40, step = 1,
    }))
    stack:Add(UI:Slider(content, {
        label = L["Gap between sections"], path = "panel.sectionGap", min = 0, max = 40, step = 1,
    }))
    stack:Add(UI:Slider(content, {
        label = L["Section header spacing"], path = "panel.headerStep", min = 0, max = 40, step = 1,
        tooltip = L["Set to 0 to remove section headers entirely."],
    }))

    stack:Gap(10)
    stack:Add(UI:Header(content, L["Background"]))

    stack:Add(UI:Dropdown(content, {
        label = L["Background texture"], path = "panel.bgTexture",
        values = mediaValues("background"), preview = "background",
    }))
    stack:Add(UI:Color(content, { label = L["Background color and transparency"], path = "panel.bgColor" }))
    stack:Add(UI:Check(content, { label = L["Tile the background"], path = "panel.bgTile" }))
    stack:Add(UI:Slider(content, {
        label = L["Tile size"], path = "panel.bgTileSize", min = 8, max = 256, step = 1,
    }))

    stack:Gap(10)
    stack:Add(UI:Header(content, L["Border"]))

    stack:Add(UI:Dropdown(content, {
        label = L["Border style"], path = "panel.borderStyle", values = mediaValues("border"),
    }))
    stack:Add(UI:Color(content, { label = L["Border color and transparency"], path = "panel.borderColor" }))
    stack:Add(UI:Slider(content, {
        label = L["Border thickness"], path = "panel.borderSize", min = 1, max = 32, step = 1,
        tooltip = L["Only affects pixel-style borders; textured borders use their own size."],
    }))
    stack:Add(UI:Slider(content, {
        label = L["Border inset"], path = "panel.borderInset", min = -16, max = 16, step = 1,
    }))

    stack:Gap(10)
    stack:Add(UI:Header(content, L["Title"]))

    stack:Add(UI:Check(content, { label = L["Show title"], path = "panel.showTitle" }))
    stack:Add(UI:Dropdown(content, {
        label = L["Title shows"], path = "panel.titleMode", values = TITLE_MODE_VALUES,
    }))
    stack:Add(UI:Dropdown(content, {
        label = L["Title alignment"], path = "panel.titleAlign", values = ALIGN_VALUES,
    }))
    stack:Add(UI:EditBox(content, {
        label = L["Item level format"], path = "panel.titleFormat",
        tooltip = L["Tokens: $equipped, $overall, $name, $spec, $class, $level"],
    }))
    stack:Add(UI:Note(content, L["Tokens: $equipped  $overall  $name  $spec  $class  $level"]))
    stack:Add(UI:Slider(content, {
        label = L["Item level decimals"], path = "panel.titleDecimals", min = 0, max = 2, step = 1,
    }))
    stack:Add(UI:EditBox(content, { label = L["Custom title text"], path = "panel.titleText" }))

    stack:Gap(10)
    stack:Add(UI:Header(content, L["Divider"]))

    stack:Add(UI:Check(content, { label = L["Show divider under title"], path = "panel.showDivider" }))
    stack:Add(UI:Color(content, { label = L["Divider color"], path = "panel.dividerColor" }))
    stack:Add(UI:Slider(content, {
        label = L["Divider thickness"], path = "panel.dividerThickness", min = 1, max = 8, step = 1,
    }))
end

--------------------------------------------------------------------------------
-- PAGE: ROWS & BARS
--------------------------------------------------------------------------------
local function buildBars(content, stack)
    stack:Add(UI:Header(content, L["Row style"]))

    stack:Add(UI:Dropdown(content, {
        label = L["Draw rows as"], path = "bars.style", values = ROW_STYLE_VALUES,
        tooltip = L["Bars draw a status bar per stat. Text only draws a single colored line per stat."],
    }))
    stack:Add(UI:Dropdown(content, {
        label = L["Text alignment (text style)"], path = "bars.align", values = ALIGN_VALUES,
    }))
    stack:Add(UI:EditBox(content, {
        label = L["Label/value separator (text style)"], path = "bars.textSep",
        tooltip = L["Placed between the stat name and its value, e.g. ': '"],
    }))
    stack:Add(UI:Slider(content, {
        label = L["Line height (text style)"], path = "bars.textHeight", min = 6, max = 40, step = 1,
    }))

    stack:Gap(10)
    stack:Add(UI:Header(content, L["Bar appearance"]))

    stack:Add(UI:Dropdown(content, {
        label = L["Bar texture"], path = "bars.texture",
        values = mediaValues("statusbar"), preview = "statusbar",
    }))
    stack:Add(UI:Slider(content, { label = L["Bar height"], path = "bars.height", min = 4, max = 48, step = 1 }))
    stack:Add(UI:Slider(content, { label = L["Space between bars"], path = "bars.spacing", min = 0, max = 30, step = 1 }))
    stack:Add(UI:Slider(content, { label = L["Horizontal inset"], path = "bars.inset", min = 0, max = 40, step = 1 }))
    stack:Add(UI:Slider(content, {
        label = L["Bar opacity"], path = "bars.alpha", min = 0, max = 1, step = 0.01, decimals = 2,
    }))
    stack:Add(UI:Check(content, { label = L["Fill from the right"], path = "bars.reverseFill" }))

    stack:Gap(10)
    stack:Add(UI:Header(content, L["Bar colors"]))

    stack:Add(UI:Dropdown(content, {
        label = L["Color mode"], path = "bars.colorMode", values = COLOR_MODE_VALUES,
        tooltip = L["Per-stat colors are set on the Stats page."],
    }))
    stack:Add(UI:Color(content, { label = L["Single color"], path = "bars.singleColor" }))
    stack:Add(UI:Color(content, { label = L["Gradient: low value"], path = "bars.gradientLow" }))
    stack:Add(UI:Color(content, { label = L["Gradient: high value"], path = "bars.gradientHigh" }))

    stack:Gap(10)
    stack:Add(UI:Header(content, L["Bar background"]))

    stack:Add(UI:Dropdown(content, {
        label = L["Track texture"], path = "bars.trackTexture",
        values = mediaValues("background"), preview = "background",
    }))
    stack:Add(UI:Color(content, { label = L["Track color and transparency"], path = "bars.trackColor" }))
    stack:Add(UI:Check(content, {
        label = L["Tint track with the stat color"], path = "bars.trackUseStatColor",
    }))
    stack:Add(UI:Slider(content, {
        label = L["Track tint opacity"], path = "bars.trackStatAlpha",
        min = 0, max = 1, step = 0.01, decimals = 2,
    }))

    stack:Gap(10)
    stack:Add(UI:Header(content, L["Bar border"]))

    stack:Add(UI:Dropdown(content, {
        label = L["Border style"], path = "bars.borderStyle", values = mediaValues("border"),
    }))
    stack:Add(UI:Color(content, { label = L["Border color"], path = "bars.borderColor" }))
    stack:Add(UI:Slider(content, { label = L["Border thickness"], path = "bars.borderSize", min = 1, max = 16, step = 1 }))

    stack:Gap(10)
    stack:Add(UI:Header(content, L["Motion"]))

    stack:Add(UI:Check(content, {
        label = L["Animate value changes"], path = "bars.smooth",
        tooltip = L["Eases bars toward new values instead of snapping."],
    }))
    stack:Add(UI:Slider(content, {
        label = L["Animation speed"], path = "bars.smoothSpeed", min = 1, max = 30, step = 0.5, decimals = 1,
    }))
    stack:Add(UI:Check(content, { label = L["Show a spark at the fill edge"], path = "bars.spark" }))
    stack:Add(UI:Color(content, { label = L["Spark color"], path = "bars.sparkColor" }))

    stack:Gap(10)
    stack:Add(UI:Header(content, L["Row text"]))

    stack:Add(UI:Check(content, { label = L["Show stat names"], path = "bars.showLabel" }))
    stack:Add(UI:Check(content, { label = L["Show values"], path = "bars.showValue" }))
    stack:Add(UI:Check(content, { label = L["Color names with the stat color"], path = "bars.labelUseStatColor" }))
    stack:Add(UI:Check(content, { label = L["Color values with the stat color"], path = "bars.valueUseStatColor" }))
    stack:Add(UI:Check(content, {
        label = L["Number prioritized stats"], path = "bars.showRank",
        tooltip = L["Prefixes stats in a priority-ordered section with 1, 2, 3..."],
    }))
    stack:Add(UI:EditBox(content, { label = L["Numbering format"], path = "bars.rankFormat" }))
    stack:Add(UI:Slider(content, { label = L["Name offset"], path = "bars.labelX", min = -40, max = 40, step = 1 }))
    stack:Add(UI:Slider(content, { label = L["Value offset"], path = "bars.valueX", min = -40, max = 40, step = 1 }))
end

--------------------------------------------------------------------------------
-- PAGE: FONTS
--------------------------------------------------------------------------------
local FONT_ELEMENTS = {
    { name = L["Title"],          value = "title" },
    { name = L["Section header"], value = "header" },
    { name = L["Stat name"],      value = "label" },
    { name = L["Stat value"],     value = "value" },
    { name = L["Priority line"],  value = "priority" },
    { name = L["Footer"],         value = "footer" },
}

local function buildFonts(content, stack)
    local selected = "title"

    stack:Add(UI:Header(content, L["Font"]))

    stack:Add(UI:Dropdown(content, {
        label = L["Font face (all text)"], path = "font.face",
        values = mediaValues("font"), preview = "font",
    }))
    stack:Add(UI:Check(content, { label = L["Drop shadow"], path = "font.shadow" }))
    stack:Add(UI:Color(content, { label = L["Shadow color"], path = "font.shadowColor" }))
    stack:Add(UI:Slider(content, { label = L["Shadow X offset"], path = "font.shadowX", min = -5, max = 5, step = 1 }))
    stack:Add(UI:Slider(content, { label = L["Shadow Y offset"], path = "font.shadowY", min = -5, max = 5, step = 1 }))

    stack:Gap(10)
    stack:Add(UI:Header(content, L["Per-element size and color"]))

    stack:Add(UI:Dropdown(content, {
        label = L["Editing"], values = FONT_ELEMENTS,
        get = function() return selected end,
        set = function(value) selected = value end,
        refreshAll = true,
    }))

    local function element()
        return SP.db.font.elements[selected]
    end

    stack:Add(UI:Slider(content, {
        label = L["Size"], min = 6, max = 40, step = 1,
        get = function() return element().size end,
        set = function(value) element().size = value; SP:Refresh() end,
    }))
    stack:Add(UI:Dropdown(content, {
        label = L["Outline"], values = fontFlagValues,
        get = function() return element().flags end,
        set = function(value) element().flags = value; SP:Refresh() end,
    }))
    stack:Add(UI:Color(content, {
        label = L["Color"],
        get = function()
            local c = element().color or { 1, 1, 1, 1 }
            return c[1], c[2], c[3], c[4] or 1
        end,
        set = function(r, g, b, a) element().color = { r, g, b, a } end,
    }))

    stack:Add(UI:Note(content, L["Stat name and value colors are overridden when 'Color with the stat color' is enabled on the Rows & Bars page."]))
end

--------------------------------------------------------------------------------
-- PAGE: STATS
--------------------------------------------------------------------------------
local function buildStats(content, stack)
    local selected = "Crit"

    local function cfg()
        return SP.db.stats[selected] or {}
    end

    stack:Add(UI:Header(content, L["Per-stat settings"]))

    stack:Add(UI:Dropdown(content, {
        label = L["Editing stat"], values = statValues,
        get = function() return selected end,
        set = function(value) selected = value end,
        refreshAll = true,
    }))

    stack:Add(UI:Check(content, {
        label = L["Show this stat"],
        get = function() return cfg().enabled end,
        set = function(value) cfg().enabled = value; SP:Refresh() end,
    }))
    stack:Add(UI:Color(content, {
        label = L["Stat color"],
        get = function()
            local c = cfg().color or { 1, 1, 1, 1 }
            return c[1], c[2], c[3], c[4] or 1
        end,
        set = function(r, g, b, a) cfg().color = { r, g, b, a } end,
    }))
    stack:Add(UI:Check(content, {
        label = L["Use class color for this stat"],
        get = function() return cfg().useClassColor end,
        set = function(value) cfg().useClassColor = value; SP:Refresh() end,
    }))
    stack:Add(UI:EditBox(content, {
        label = L["Display name (blank for default)"],
        get = function() return cfg().label or "" end,
        set = function(value)
            value = value:trim()
            cfg().label = (value ~= "") and value or nil
            SP:Refresh()
        end,
    }))
    stack:Add(UI:EditBox(content, {
        label = L["Value format"],
        get = function() return cfg().format or "" end,
        set = function(value) cfg().format = value; SP:Refresh() end,
    }))
    stack:Add(UI:Note(content, L["Tokens: $value  $rating  $valuec  $ratingc  $max  $label  $peak  $yards\nExample: '$rating - $value%' shows '285 - 10.65%'."]))
    stack:Add(UI:Slider(content, {
        label = L["Decimal places"], min = 0, max = 4, step = 1,
        get = function() return cfg().decimals end,
        set = function(value) cfg().decimals = value; SP:Refresh() end,
    }))

    stack:Gap(10)
    stack:Add(UI:Header(content, L["Bar scale"]))

    stack:Add(UI:Dropdown(content, {
        label = L["Bar fill"], values = FILL_VALUES,
        get = function() return cfg().fill end,
        set = function(value) cfg().fill = value; SP:Refresh() end,
    }))
    stack:Add(UI:Slider(content, {
        label = L["Value at a full bar"], min = 1, max = 20000, step = 1,
        get = function() return cfg().max end,
        set = function(value) cfg().max = value; SP:Refresh() end,
    }))
    stack:Add(UI:Check(content, {
        label = L["Grow the scale automatically"],
        tooltip = L["Raises the full-bar value whenever the stat exceeds it. Useful for Speed, which has no ceiling while skyriding."],
        get = function() return cfg().autoMax end,
        set = function(value)
            cfg().autoMax = value
            SP.ResetRuntimeMax()
            SP:Refresh()
        end,
    }))

    stack:Gap(10)
    stack:Add(UI:ButtonRow(content, {
        { text = L["Reset all stats"], width = 140, onClick = function()
            Config:Reset("stats")
            UI:RefreshAll()
        end },
    }))
end

--------------------------------------------------------------------------------
-- PAGE: SECTIONS
--------------------------------------------------------------------------------
local function buildSections(content, stack)
    local selectedIndex = 2   -- Enhancements by default

    local function section()
        return SP.db.sections[selectedIndex] or SP.db.sections[1]
    end

    local function sectionValues()
        local out = {}
        for index, s in ipairs(SP.db.sections) do
            out[#out + 1] = { name = s.title or s.id, value = index }
        end
        return out
    end

    stack:Add(UI:Header(content, L["Sections"]))
    stack:Add(UI:Note(content, L["Sections are drawn top to bottom in this order. Each one holds any set of stats you like."]))

    stack:Add(UI:Dropdown(content, {
        label = L["Editing section"], values = sectionValues,
        get = function() return selectedIndex end,
        set = function(value) selectedIndex = value end,
        refreshAll = true,
    }))

    stack:Add(UI:EditBox(content, {
        label = L["Section title"],
        get = function() return section().title or "" end,
        set = function(value) section().title = value; SP:Refresh() end,
    }))
    stack:Add(UI:Check(content, {
        label = L["Show this section"],
        get = function() return section().enabled end,
        set = function(value) section().enabled = value; SP:Refresh() end,
    }))
    stack:Add(UI:Check(content, {
        label = L["Show the section header"],
        get = function() return section().showHeader ~= false end,
        set = function(value) section().showHeader = value; SP:Refresh() end,
    }))
    stack:Add(UI:Check(content, {
        label = L["Order by spec stat priority"],
        tooltip = L["Re-sorts this section's stats to match your specialization's priority."],
        get = function() return section().prioritized end,
        set = function(value) section().prioritized = value; SP:Refresh() end,
    }))
    stack:Add(UI:Dropdown(content, {
        label = L["Header alignment"], path = "panel.headerAlign", values = ALIGN_VALUES,
    }))

    stack:Add(UI:ButtonRow(content, {
        { text = L["Move section up"], width = 140, onClick = function()
            if selectedIndex > 1 then
                local sections = SP.db.sections
                sections[selectedIndex], sections[selectedIndex - 1] = sections[selectedIndex - 1], sections[selectedIndex]
                selectedIndex = selectedIndex - 1
                SP:Refresh()
                UI:RefreshAll()
            end
        end },
        { text = L["Move section down"], width = 140, onClick = function()
            local sections = SP.db.sections
            if selectedIndex < #sections then
                sections[selectedIndex], sections[selectedIndex + 1] = sections[selectedIndex + 1], sections[selectedIndex]
                selectedIndex = selectedIndex + 1
                SP:Refresh()
                UI:RefreshAll()
            end
        end },
    }))

    stack:Gap(10)
    stack:Add(UI:Header(content, L["Stats in this section"]))

    -- The membership list grows and shrinks as stats are added or removed, so
    -- it is placed LAST on the page - anything stacked below it would be
    -- overlapped the moment the list changed height.
    local list = CreateFrame("Frame", nil, content)
    list:SetHeight(10)
    list.rows = {}

    local addDropdown

    local function refreshList()
        for _, row in ipairs(list.rows) do row:Hide() end

        local members = section().stats or {}
        local y = 0

        for index, statName in ipairs(members) do
            local row = list.rows[index]
            if not row then
                row = CreateFrame("Frame", nil, list)
                row:SetHeight(22)

                row.check = CreateFrame("CheckButton", nil, row)
                row.check:SetSize(20, 20)
                row.check:SetPoint("LEFT", row, "LEFT", 0, 0)
                row.check:SetNormalTexture([[Interface\Buttons\UI-CheckBox-Up]])
                row.check:SetCheckedTexture([[Interface\Buttons\UI-CheckBox-Check]])
                row.check:SetHighlightTexture([[Interface\Buttons\UI-CheckBox-Highlight]], "ADD")

                row.label = row:CreateFontString(nil, "OVERLAY")
                row.label:SetFont([[Fonts\FRIZQT__.TTF]], 12, "")
                row.label:SetPoint("LEFT", row.check, "RIGHT", 4, 0)

                row.up = UI:Button(row, { text = L["Up"], width = 44, height = 20 })
                row.down = UI:Button(row, { text = L["Down"], width = 54, height = 20 })
                row.remove = UI:Button(row, { text = L["Remove"], width = 66, height = 20 })

                row.remove:SetPoint("RIGHT", row, "RIGHT", 0, 0)
                row.down:SetPoint("RIGHT", row.remove, "LEFT", -4, 0)
                row.up:SetPoint("RIGHT", row.down, "LEFT", -4, 0)

                list.rows[index] = row
            end

            row:SetPoint("TOPLEFT", list, "TOPLEFT", 0, -y)
            row:SetPoint("TOPRIGHT", list, "TOPRIGHT", 0, -y)

            local def = SP.STAT_DEFS[statName]
            local statCfg = SP.db.stats[statName]
            row.label:SetText(def and def.name or statName)
            row.check:SetChecked(statCfg and statCfg.enabled)

            row.check:SetScript("OnClick", function(self)
                if statCfg then
                    statCfg.enabled = self:GetChecked() and true or false
                    SP:Refresh()
                end
            end)
            row.up:SetScript("OnClick", function()
                if index > 1 then
                    members[index], members[index - 1] = members[index - 1], members[index]
                    SP:Refresh()
                    refreshList()
                end
            end)
            row.down:SetScript("OnClick", function()
                if index < #members then
                    members[index], members[index + 1] = members[index + 1], members[index]
                    SP:Refresh()
                    refreshList()
                end
            end)
            row.remove:SetScript("OnClick", function()
                table.remove(members, index)
                SP:Refresh()
                refreshList()
                if addDropdown then addDropdown:Refresh() end
            end)

            row:Show()
            y = y + 24
        end

        list:SetHeight(math.max(10, y))
        if Options.RelayoutCurrent then Options:RelayoutCurrent() end
    end

    list.refreshList = refreshList

    -- Only offer stats that aren't already in this section.
    addDropdown = UI:Dropdown(content, {
        label = L["Add a stat to this section"],
        values = function()
            local present = {}
            for _, statName in ipairs(section().stats or {}) do present[statName] = true end

            local out = {}
            for _, statName in ipairs(SP.STAT_ORDER) do
                if not present[statName] then
                    local def = SP.STAT_DEFS[statName]
                    out[#out + 1] = { name = def and def.name or statName, value = statName }
                end
            end
            if #out == 0 then out[1] = { name = L["(every stat is already here)"], value = "" } end
            return out
        end,
        get = function() return "" end,
        set = function(value)
            if value ~= "" then
                local members = section().stats or {}
                members[#members + 1] = value
                section().stats = members
                SP:Refresh()
                refreshList()
            end
        end,
    })
    stack:Add(addDropdown)

    stack:Add(UI:ButtonRow(content, {
        { text = L["Reset sections"], width = 140, onClick = function()
            Config:Reset("sections")
            selectedIndex = 1
            refreshList()
            UI:RefreshAll()
        end },
    }))

    -- Placed last so its changing height never pushes into another control.
    stack:Add(list, 10)

    -- Rebuild the list whenever the page is refreshed (section switch, preset...).
    local watcher = CreateFrame("Frame", nil, content)
    watcher:SetSize(1, 1)
    watcher.Refresh = refreshList
    UI.widgets[#UI.widgets + 1] = watcher

    refreshList()
end

--------------------------------------------------------------------------------
-- PAGE: FOOTER
--------------------------------------------------------------------------------
local function buildFooter(content, stack)
    stack:Add(UI:Header(content, L["Footer line"]))

    stack:Add(UI:Check(content, { label = L["Show the footer"], path = "footer.enabled" }))
    stack:Add(UI:Check(content, { label = L["Frames per second"], path = "footer.showFPS" }))
    stack:Add(UI:Check(content, { label = L["Home latency"], path = "footer.showHomeLatency" }))
    stack:Add(UI:Check(content, { label = L["World latency"], path = "footer.showWorldLatency" }))
    stack:Add(UI:Check(content, { label = L["Addon memory use"], path = "footer.showMemory" }))
    stack:Add(UI:EditBox(content, { label = L["Separator between entries"], path = "footer.separator" }))

    stack:Gap(10)
    stack:Add(UI:Header(content, L["Formats"]))

    stack:Add(UI:EditBox(content, { label = L["FPS format"], path = "footer.fpsFormat" }))
    stack:Add(UI:EditBox(content, { label = L["Home latency format"], path = "footer.homeFormat" }))
    stack:Add(UI:EditBox(content, { label = L["World latency format"], path = "footer.worldFormat" }))
    stack:Add(UI:EditBox(content, { label = L["Memory format"], path = "footer.memoryFormat" }))
    stack:Add(UI:Note(content, L["These use standard number formats: %d for a whole number, %.1f for one decimal."]))

    stack:Gap(10)
    stack:Add(UI:Header(content, L["Performance coloring"]))

    stack:Add(UI:Check(content, {
        label = L["Color by performance"], path = "footer.colorize",
        tooltip = L["Turns FPS and latency green, yellow or red depending on the thresholds below."],
    }))
    stack:Add(UI:Color(content, { label = L["Good"], path = "footer.goodColor" }))
    stack:Add(UI:Color(content, { label = L["Fair"], path = "footer.okColor" }))
    stack:Add(UI:Color(content, { label = L["Poor"], path = "footer.badColor" }))
    stack:Add(UI:Slider(content, { label = L["FPS considered good"], path = "footer.fpsGood", min = 20, max = 240, step = 1 }))
    stack:Add(UI:Slider(content, { label = L["FPS considered poor"], path = "footer.fpsBad", min = 5, max = 120, step = 1 }))
    stack:Add(UI:Slider(content, { label = L["Latency considered good (ms)"], path = "footer.msGood", min = 10, max = 400, step = 5 }))
    stack:Add(UI:Slider(content, { label = L["Latency considered poor (ms)"], path = "footer.msBad", min = 50, max = 1000, step = 5 }))
end

--------------------------------------------------------------------------------
-- PAGE: PRIORITY
--------------------------------------------------------------------------------
local SECONDARY = { "Crit", "Haste", "Mastery", "Versatility" }

local function buildPriority(content, stack)
    local weightText = ""  -- the pasted weight/order box

    stack:Add(UI:Header(content, L["Priority line"]))

    stack:Add(UI:Check(content, { label = L["Show the priority chain"], path = "priorityLine.enabled" }))
    stack:Add(UI:EditBox(content, { label = L["Separator"], path = "priorityLine.separator" }))
    stack:Add(UI:Check(content, { label = L["Color each stat name"], path = "priorityLine.colorize" }))
    stack:Add(UI:Check(content, { label = L["Prefix with the spec name"], path = "priorityLine.showSpec" }))

    stack:Gap(10)
    stack:Add(UI:Header(content, L["Priority for your current spec"]))
    stack:Add(UI:Note(content, L["The built-in order is a general-purpose baseline. Sim your own character for the authoritative answer, then set it here."]))

    local specLabel = UI:Note(content, L[""])
    stack:Add(specLabel)
    specLabel.Refresh = function(self)
        local _, specName = SP:GetCurrentPriority()
        self.text:SetText("Current specialization: " .. (specName or "unknown"))
    end
    UI.widgets[#UI.widgets + 1] = specLabel

    -- Four dropdowns, one per priority slot.
    local function currentList()
        local priority = SP:GetCurrentPriority()
        return priority
    end

    for slot = 1, 4 do
        stack:Add(UI:Dropdown(content, {
            label = L["Priority "] .. slot,
            values = function()
                local out = {}
                for _, statName in ipairs(SECONDARY) do
                    out[#out + 1] = { name = SP.STAT_DEFS[statName].name, value = statName }
                end
                return out
            end,
            get = function() return currentList()[slot] end,
            set = function(value)
                local _, _, specID = SP:GetCurrentPriority()
                if not specID then return end

                -- Build a full four-entry order: the picked stat lands in this
                -- slot and whatever it displaced fills the gap, so the list is
                -- always a valid permutation.
                local order = {}
                for index, statName in ipairs(currentList()) do order[index] = statName end

                local existing
                for index, statName in ipairs(order) do
                    if statName == value then
                        existing = index
                        break
                    end
                end
                if existing then
                    order[existing] = order[slot]
                end
                order[slot] = value

                SP.db.customPriority[specID] = order
                SP:Refresh()
            end,
            refreshAll = true,
        }))
    end

    stack:Gap(10)
    stack:Add(UI:Header(content, L["Paste a stat weight string"]))
    stack:Add(UI:Note(content, L["Paste a Pawn string (from Raidbots, a sim, or a stat site) or a plain order like 'Mastery > Haste > Crit > Versatility'. StatPanel reads the four secondaries and sets the order for your current spec."]))

    local weightBox = UI:EditBox(content, {
        label = L["Weights or order"],
        multiline = true,
        manualCommit = true,
        get = function() return weightText end,
        set = function(value) weightText = value end,
    })
    stack:Add(weightBox)

    stack:Add(UI:ButtonRow(content, {
        { text = L["Apply pasted weights"], width = 180, onClick = function()
            local _, specName, specID = SP:GetCurrentPriority()
            if not specID then
                SP:Print(L["no active specialization to apply to."])
                return
            end
            local order, err = SP:ParsePriorityString(weightBox.edit:GetText())
            if not order then
                SP:Print(err)
                return
            end
            SP.db.customPriority[specID] = order
            weightBox.edit:SetText("")
            weightText = ""
            SP:Print(string.format(L["priority for %s set to %s."],
                specName or L["your spec"], table.concat(order, " > ")))
            SP:Refresh()
            UI:RefreshAll()
        end },
    }))

    stack:Gap(10)
    stack:Add(UI:ButtonRow(content, {
        { text = L["Use the built-in order"], width = 170, onClick = function()
            local _, _, specID = SP:GetCurrentPriority()
            if specID then
                SP.db.customPriority[specID] = nil
                SP:Refresh()
                UI:RefreshAll()
            end
        end },
    }))
end

--------------------------------------------------------------------------------
-- PAGE: PRESETS
--------------------------------------------------------------------------------
local function buildPresets(content, stack)
    stack:Add(UI:Header(content, L["Presets"]))
    stack:Add(UI:Note(content, L["A preset overwrites appearance settings in the current profile. Your position, visibility rules and profiles are left alone."]))

    for _, name in ipairs(Presets.order) do
        local preset = Presets.list[name]
        if preset then
            stack:Gap(4)
            stack:Add(UI:ButtonRow(content, {
                { text = name, width = 150, onClick = function()
                    Presets:Apply(name)
                    UI:RefreshAll()
                end },
            }))
            stack:Add(UI:Note(content, preset.desc or ""))
        end
    end

    stack:Gap(12)
    stack:Add(UI:Header(content, L["Start over"]))
    stack:Add(UI:ButtonRow(content, {
        { text = L["Reset this profile"], width = 160, onClick = function()
            Config:Reset()
            UI:RefreshAll()
        end },
    }))
end

--------------------------------------------------------------------------------
-- PAGE: PROFILES
--------------------------------------------------------------------------------
local function buildProfiles(content, stack)
    local newName = ""       -- "New profile name" box
    local importText = ""    -- the pasted import-string box
    local importTarget = ""  -- "Import into profile" name box

    stack:Add(UI:Header(content, L["Profile"]))
    stack:Add(UI:Note(content, L["Each character remembers which profile it uses, so you can share one look across alts or give each its own."]))

    stack:Add(UI:Dropdown(content, {
        label = L["Active profile"],
        values = function() return Config:ProfileList() end,
        get = function() return Config:CurrentProfile() end,
        set = function(value)
            Config:SetProfile(value)
            UI:RefreshAll()
        end,
        refreshAll = true,
    }))

    stack:Add(UI:EditBox(content, {
        label = L["New profile name"],
        get = function() return newName end,
        set = function(value) newName = value end,
    }))

    stack:Add(UI:ButtonRow(content, {
        { text = L["Create"], width = 100, onClick = function()
            local ok, err = Config:NewProfile(newName)
            if ok then
                Config:SetProfile(newName)
                newName = ""
            else
                SP:Print(err)
            end
            UI:RefreshAll()
        end },
        { text = L["Copy current"], width = 110, onClick = function()
            local ok, err = Config:NewProfile(newName, Config:CurrentProfile())
            if ok then
                Config:SetProfile(newName)
                newName = ""
            else
                SP:Print(err)
            end
            UI:RefreshAll()
        end },
        { text = L["Delete current"], width = 120, onClick = function()
            local name = Config:CurrentProfile()
            local ok, err = Config:DeleteProfile(name)
            if not ok then SP:Print(err) else SP:Print(L["Deleted profile '%s'."]:format(name)) end
            UI:RefreshAll()
        end },
    }))

    stack:Gap(10)
    stack:Add(UI:Header(content, L["Share"]))
    stack:Add(UI:Note(content, L["Export produces a string you can paste to someone else. Importing overwrites the profile you name below, or the active one if you leave it blank."]))

    local exportBox = UI:EditBox(content, {
        label = L["Export string"],
        multiline = true,
        manualCommit = true,
        selectAllOnClick = true,
        get = function() return "" end,
        set = function() end,
    })
    stack:Add(exportBox)

    stack:Add(UI:ButtonRow(content, {
        { text = L["Generate export"], width = 140, onClick = function()
            exportBox.edit:SetText(Config:Export() or "")
            exportBox.edit:HighlightText()
            exportBox.edit:SetFocus()
        end },
    }))

    local importBox = UI:EditBox(content, {
        label = L["Import string"],
        multiline = true,
        manualCommit = true,
        get = function() return importText end,
        set = function(value) importText = value end,
    })
    stack:Add(importBox)

    stack:Add(UI:EditBox(content, {
        label = L["Import into profile (blank = active)"],
        get = function() return importTarget end,
        set = function(value) importTarget = value end,
    }))

    stack:Add(UI:ButtonRow(content, {
        { text = L["Import"], width = 120, onClick = function()
            local name, err = Config:Import(importBox.edit:GetText(), importTarget)
            if name then
                SP:Print(L["Imported into profile '%s'."]:format(name))
                importBox.edit:SetText("")
            else
                SP:Print(err)
            end
            UI:RefreshAll()
        end },
    }))
end

--------------------------------------------------------------------------------
-- PAGE: ANNOUNCE
--------------------------------------------------------------------------------
local function buildAnnounce(content, stack)
    local whisperTarget = ""

    stack:Add(UI:Header(content, L["Announce"]))
    stack:Add(UI:Note(content, L["Sends a summary of your gear to chat. Nothing is ever sent automatically - only when you use the button, the slash command or the right-click menu."]))

    stack:Add(UI:Dropdown(content, {
        label = L["Send to"], path = "announce.channel", values = SP.Announce.channels,
    }))
    stack:Add(UI:EditBox(content, {
        label = L["Whisper to (for the Whisper channel)"],
        get = function() return whisperTarget end,
        set = function(value) whisperTarget = value end,
    }))
    stack:Add(UI:EditBox(content, { label = L["Prefix"], path = "announce.prefix" }))

    stack:Gap(10)
    stack:Add(UI:Header(content, L["Include"]))

    stack:Add(UI:Check(content, { label = L["Item level"], path = "announce.includeItemLevel" }))
    stack:Add(UI:Check(content, { label = L["Specialization"], path = "announce.includeSpec" }))
    stack:Add(UI:Check(content, { label = L["Stats"], path = "announce.includeStats" }))
    stack:Add(UI:Check(content, { label = L["Stat priority"], path = "announce.includePriority" }))
    stack:Add(UI:Check(content, { label = L["Session peak speed"], path = "announce.includeSpeed" }))
    stack:Add(UI:Check(content, { label = L["Missing enchants and sockets"], path = "announce.includeGear" }))

    stack:Add(UI:Note(content, L["The game protects most combat stats and will not let any addon send them to chat, so those are left out automatically. Item level, spec, speed and gear warnings all go through. If a future patch unprotects a stat it will start appearing with no change needed."]))

    stack:Gap(10)
    stack:Add(UI:ButtonRow(content, {
        { text = L["Preview"], width = 110, onClick = function()
            SP.Announce:Send("SELF")
        end },
        { text = L["Announce now"], width = 130, onClick = function()
            SP.Announce:Send(SP.db.announce.channel, whisperTarget)
        end },
    }))
end

--------------------------------------------------------------------------------
-- PAGE: GEAR
--------------------------------------------------------------------------------
local function buildGear(content, stack)
    stack:Add(UI:Header(content, L["Equipped gear"]))
    stack:Add(UI:Note(content, L["Item data is not protected by the game, so unlike the combat stats this can be read in full."]))

    stack:Add(UI:ButtonRow(content, {
        { text = L["Refresh"], width = 110, onClick = function() UI:RefreshAll() end },
        { text = L["Print report"], width = 130, onClick = function() SP.Gear:PrintReport() end },
    }))

    local summary = UI:Note(content, L[""])
    stack:Add(summary)

    -- Reusable rows, rebuilt on every refresh.
    local list = CreateFrame("Frame", nil, content)
    list:SetHeight(10)
    list.rows = {}

    local function refresh()
        local audit = SP.Gear:Audit()

        local warning = SP.Gear:WarningText()
        local tier = audit.tierCount
            and string.format("  Tier set %d/%d.", audit.tierCount, audit.tierTotal) or ""
        summary.text:SetText(string.format("Average equipped item level %.2f.%s  %s",
            audit.average, tier, warning or "Nothing missing."))

        for _, row in ipairs(list.rows) do row:Hide() end

        local y = 0
        for index, slot in ipairs(audit.slots) do
            local row = list.rows[index]
            if not row then
                row = CreateFrame("Frame", nil, list)
                row:SetHeight(18)

                row.name = row:CreateFontString(nil, "OVERLAY")
                row.name:SetFont([[Fonts\FRIZQT__.TTF]], 12, "")
                row.name:SetPoint("LEFT", row, "LEFT", 0, 0)
                row.name:SetJustifyH("LEFT")

                row.info = row:CreateFontString(nil, "OVERLAY")
                row.info:SetFont([[Fonts\FRIZQT__.TTF]], 12, "")
                row.info:SetPoint("LEFT", row, "LEFT", 90, 0)
                row.info:SetPoint("RIGHT", row, "RIGHT", 0, 0)
                row.info:SetJustifyH("LEFT")

                list.rows[index] = row
            end

            row:SetPoint("TOPLEFT", list, "TOPLEFT", 0, -y)
            row:SetPoint("TOPRIGHT", list, "TOPRIGHT", 0, -y)

            row.name:SetText(slot.name)
            row.name:SetTextColor(0.75, 0.75, 0.8)

            if slot.empty then
                if slot.id == 17 then
                    row.info:SetText("-")
                    row.info:SetTextColor(0.5, 0.5, 0.55)
                else
                    row.info:SetText("empty")
                    row.info:SetTextColor(0.9, 0.35, 0.35)
                end
            else
                local notes = {}
                if slot.needsEnchant then notes[#notes + 1] = "no enchant" end
                if slot.emptySockets > 0 then
                    notes[#notes + 1] = slot.emptySockets .. " empty socket"
                end
                if slot.lowGems > 0 then
                    notes[#notes + 1] = slot.lowGems .. " rare gem"
                end

                local track = ""
                if slot.upgradeTrack and slot.upgradeCur and slot.upgradeMax then
                    track = string.format("   %s %d/%d",
                        slot.upgradeTrack, slot.upgradeCur, slot.upgradeMax)
                end

                local isLowest = audit.lowest and slot.id == audit.lowest.id
                row.info:SetText(string.format("%d%s%s%s", slot.itemLevel, track,
                    #notes > 0 and ("   " .. table.concat(notes, ", ")) or "",
                    isLowest and "   (lowest)" or ""))

                if #notes > 0 then
                    row.info:SetTextColor(0.95, 0.6, 0.25)
                elseif isLowest then
                    row.info:SetTextColor(0.85, 0.85, 0.55)
                else
                    row.info:SetTextColor(0.9, 0.9, 0.92)
                end
            end

            row:Show()
            y = y + 19
        end

        list:SetHeight(math.max(10, y))
        if Options.RelayoutCurrent then Options:RelayoutCurrent() end
    end

    -- Placed last: its height changes with the number of slots shown.
    stack:Add(list, 10)

    local watcher = CreateFrame("Frame", nil, content)
    watcher:SetSize(1, 1)
    watcher.Refresh = refresh
    UI.widgets[#UI.widgets + 1] = watcher

    refresh()
end

--------------------------------------------------------------------------------
-- PAGE: AUTOMATION
--------------------------------------------------------------------------------
local function buildAutomation(content, stack)
    local function settings() return SP.AutoProfile:Settings() end

    local function profileChoices()
        local out = { { name = L["(no rule)"], value = "" } }
        for _, name in ipairs(Config:ProfileList()) do
            out[#out + 1] = { name = name, value = name }
        end
        return out
    end

    stack:Add(UI:Header(content, L["Automatic profile switching"]))
    stack:Add(UI:Note(content, L["Rules are saved per character. A content rule beats a specialization rule, so you can keep a spec profile generally and still force a different one inside a raid. Anything left as '(no rule)' is ignored."]))

    stack:Add(UI:Check(content, {
        label = L["Switch profiles automatically"],
        get = function() return settings().enabled end,
        set = function(value)
            settings().enabled = value
            if value then SP.AutoProfile:Apply() end
        end,
    }))

    stack:Gap(10)
    stack:Add(UI:Header(content, L["By content"]))

    for _, context in ipairs(SP.AutoProfile.contexts) do
        stack:Add(UI:Dropdown(content, {
            label = context.name,
            values = profileChoices,
            get = function() return settings().byContext[context.value] or "" end,
            set = function(value)
                settings().byContext[context.value] = (value ~= "") and value or nil
                SP.AutoProfile:Apply()
            end,
        }))
    end

    stack:Gap(10)
    stack:Add(UI:Header(content, L["By specialization"]))
    stack:Add(UI:Note(content, L["Only your current specialization is listed. Switch spec and come back to set a rule for another one."]))

    local specLabel = UI:Note(content, L[""])
    stack:Add(specLabel)
    specLabel.Refresh = function(self)
        local _, specName = SP:GetCurrentPriority()
        self.text:SetText("Current specialization: " .. (specName or "unknown"))
    end
    UI.widgets[#UI.widgets + 1] = specLabel

    stack:Add(UI:Dropdown(content, {
        label = L["Profile for this specialization"],
        values = profileChoices,
        get = function()
            local _, _, specID = SP:GetCurrentPriority()
            return specID and settings().bySpec[specID] or ""
        end,
        set = function(value)
            local _, _, specID = SP:GetCurrentPriority()
            if specID then
                settings().bySpec[specID] = (value ~= "") and value or nil
                SP.AutoProfile:Apply()
            end
        end,
    }))

    stack:Gap(10)
    stack:Add(UI:ButtonRow(content, {
        { text = L["Apply rules now"], width = 150, onClick = function()
            -- Apply() returns false both when nothing matches and when the match
            -- is the profile you are already on; resolve first so the two cases
            -- read differently instead of both claiming "no rule matches".
            local target = SP.AutoProfile:Resolve()
            if not target then
                SP:Print(L["no rule matches your current spec or location."])
            elseif target == SP.Config:CurrentProfile() then
                SP:Print(L["already on '%s', the profile your rules call for."]:format(target))
            else
                SP.AutoProfile:Apply()
            end
        end },
        { text = L["Clear all rules"], width = 140, onClick = function()
            local s = settings()
            wipe(s.bySpec)
            wipe(s.byContext)
            UI:RefreshAll()
            SP:Print(L["cleared this character's automatic rules."])
        end },
    }))
end

--------------------------------------------------------------------------------
-- PAGE REGISTRY
--------------------------------------------------------------------------------
local PAGES = {
    { id = "general",  name = L["General"],     build = buildGeneral },
    { id = "panel",    name = L["Panel"],       build = buildPanel },
    { id = "bars",     name = L["Rows & Bars"], build = buildBars },
    { id = "fonts",    name = L["Fonts"],       build = buildFonts },
    { id = "stats",    name = L["Stats"],       build = buildStats },
    { id = "sections", name = L["Sections"],    build = buildSections },
    { id = "footer",   name = L["Footer"],      build = buildFooter },
    { id = "priority", name = L["Priority"],    build = buildPriority },
    { id = "gear",     name = L["Gear"],        build = buildGear },
    { id = "announce", name = L["Announce"],    build = buildAnnounce },
    { id = "presets",  name = L["Presets"],     build = buildPresets },
    { id = "profiles", name = L["Profiles"],    build = buildProfiles },
    { id = "auto",     name = L["Automation"],  build = buildAutomation },
}

function Options:ShowPage(id)
    for pageID, page in pairs(pages) do
        page.scroll:SetShown(pageID == id)
        if page.tab then
            page.tab.selected:SetShown(pageID == id)
        end
    end

    local page = pages[id]
    if page and not page.built then
        page.built = true
        local stack = UI:NewStack(page.content, 4, -8, page.content:GetWidth() - 8)
        page.buildFn(page.content, stack)
        page.content:SetTotalHeight(stack:Height())
    end

    currentPage = id
    UI:RefreshAll()
end

-- Sections can change their own height; re-measure the page they live on.
function Options:RelayoutCurrent()
    local page = pages[currentPage]
    if not page or not page.built then return end
    -- The stack already positioned everything; only the total height moves.
    local lowest = 0
    for _, child in ipairs({ page.content:GetChildren() }) do
        local _, _, _, _, offsetY = child:GetPoint()
        if offsetY then
            local bottom = -offsetY + (child:GetHeight() or 0)
            if bottom > lowest then lowest = bottom end
        end
    end
    page.content:SetTotalHeight(lowest + 24)
end

--------------------------------------------------------------------------------
-- LIVE PREVIEW
--------------------------------------------------------------------------------
-- A floating box beside the Settings window that hosts the real panel while
-- you're configuring. Parented to UIParent rather than our canvas so it can sit
-- outside the Settings frame, where there's actually room for it.
local previewWindow

-- A dark panel on a dark backdrop is unreadable, and a translucent one can only
-- be judged against something. Cycle the preview background to check both.
local PREVIEW_BACKDROPS = {
    { name = L["Dark"],  color = { 0.03, 0.03, 0.04, 0.94 } },
    { name = L["Grey"],  color = { 0.40, 0.40, 0.43, 0.95 } },
    { name = L["Light"], color = { 0.88, 0.88, 0.90, 0.96 } },
    { name = L["Game"],  color = { 0, 0, 0, 0 } },
}

local function applyPreviewBackdrop()
    local index = SPAddonDB.global.previewBG or 1
    if index < 1 or index > #PREVIEW_BACKDROPS then index = 1 end

    local mode = PREVIEW_BACKDROPS[index]
    previewWindow:SetBackdropColor(unpack(mode.color))
    previewWindow.bgButton:SetText("Background: " .. mode.name)
end

local function ensurePreviewWindow()
    if previewWindow then return previewWindow end

    previewWindow = CreateFrame("Frame", "SPAddonPreview", UIParent, "BackdropTemplate")
    previewWindow:SetSize(360, 480)
    previewWindow:SetFrameStrata("FULLSCREEN_DIALOG")
    previewWindow:SetBackdrop({
        bgFile   = [[Interface\Buttons\WHITE8X8]],
        edgeFile = [[Interface\Buttons\WHITE8X8]],
        edgeSize = 1,
    })
    previewWindow:SetBackdropBorderColor(0.45, 0.50, 0.60, 1)

    -- Movable, so it can be pushed out of the way of the Settings window.
    previewWindow:SetMovable(true)
    previewWindow:EnableMouse(true)
    previewWindow:SetClampedToScreen(true)
    previewWindow:RegisterForDrag("LeftButton")
    previewWindow:SetScript("OnDragStart", previewWindow.StartMoving)
    previewWindow:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, _, relPoint, x, y = self:GetPoint()
        SPAddonDB.global.previewPos = { point = point, relPoint = relPoint, x = x, y = y }
    end)

    local heading = previewWindow:CreateFontString(nil, "OVERLAY")
    heading:SetFont([[Fonts\FRIZQT__.TTF]], 13, "")
    heading:SetTextColor(1, 0.82, 0.32)
    heading:SetPoint("TOP", previewWindow, "TOP", 0, -9)
    heading:SetText("Live Preview")

    local note = previewWindow:CreateFontString(nil, "OVERLAY")
    note:SetFont([[Fonts\FRIZQT__.TTF]], 10, "")
    note:SetTextColor(0.60, 0.60, 0.65)
    note:SetPoint("BOTTOM", previewWindow, "BOTTOM", 0, 8)
    note:SetWidth(330)
    note:SetText("The real panel, docked here. Drag this window to move it; the panel returns home when you close the options.")

    previewWindow.bgButton = CreateFrame("Button", nil, previewWindow, "UIPanelButtonTemplate")
    previewWindow.bgButton:SetSize(150, 20)
    previewWindow.bgButton:SetPoint("BOTTOM", previewWindow, "BOTTOM", 0, 26)
    previewWindow.bgButton:SetScript("OnClick", function()
        local index = (SPAddonDB.global.previewBG or 1) + 1
        if index > #PREVIEW_BACKDROPS then index = 1 end
        SPAddonDB.global.previewBG = index
        applyPreviewBackdrop()
    end)

    -- The panel gets re-parented into this slot.
    previewWindow.slot = CreateFrame("Frame", nil, previewWindow)
    previewWindow.slot:SetPoint("TOPLEFT", previewWindow, "TOPLEFT", 8, -28)
    previewWindow.slot:SetPoint("BOTTOMRIGHT", previewWindow, "BOTTOMRIGHT", -8, 52)

    applyPreviewBackdrop()
    return previewWindow
end

local function anchorPreview()
    previewWindow:ClearAllPoints()

    -- Remembered position wins, so the window stays where it was dragged.
    local saved = SPAddonDB.global.previewPos
    if saved and saved.point then
        previewWindow:SetPoint(saved.point, UIParent, saved.relPoint or saved.point, saved.x or 0, saved.y or 0)
        return
    end

    -- Otherwise sit to the left of the Settings window, if there's room.
    local anchorTo = _G.SettingsPanel or optionsFrame
    if anchorTo and anchorTo:GetLeft() and anchorTo:GetLeft() > 380 then
        previewWindow:SetPoint("TOPRIGHT", anchorTo, "TOPLEFT", -12, 0)
    else
        previewWindow:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    end
end

function Options:StartPreview()
    if not SPAddonDB.global.livePreview then return end

    -- The canvas OnShow fires once transiently when the category is registered
    -- at login, before the Settings window is ever opened. Starting the preview
    -- then docks the panel in a preview box with no options behind it, and it
    -- sits there until you open and close the options to trigger a real teardown.
    -- Only preview when the Settings window is genuinely open.
    if _G.SettingsPanel and not _G.SettingsPanel:IsShown() then return end

    ensurePreviewWindow()
    anchorPreview()
    previewWindow:Show()

    -- Deferred for the same reason as StopPreview: OnShow runs inside
    -- Blizzard's panel-showing path.
    C_Timer.After(0, function()
        if previewWindow:IsShown() then
            SP.Panel:EnterPreview(previewWindow.slot)
        end
    end)
end

function Options:StopPreview()
    if previewWindow then previewWindow:Hide() end

    -- Deliberately deferred by one frame. This is called from the canvas's
    -- OnHide, which Blizzard fires from inside HideUIPanelImplementation - a
    -- secure path. Re-parenting and rebuilding there runs our tainted code
    -- inside their call and raises "action only available to the Blizzard UI".
    -- Stepping out to the next frame takes us off that path entirely.
    C_Timer.After(0, function() SP.Panel:ExitPreview() end)
end

-- Used by the General page toggle so flipping it takes effect immediately.
function Options:RefreshPreview()
    if not optionsFrame or not optionsFrame:IsShown() then return end
    if SPAddonDB.global.livePreview then
        self:StartPreview()
    else
        self:StopPreview()
    end
end

--------------------------------------------------------------------------------
-- FRAME
--------------------------------------------------------------------------------
function SP:CreateOptionsPanel()
    if optionsFrame then return optionsFrame end

    optionsFrame = CreateFrame("Frame", "SPAddonOptions", UIParent)
    optionsFrame.name = "StatPanel"

    local title = optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("StatPanel")

    local subtitle = optionsFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
    subtitle:SetJustifyH("LEFT")
    subtitle:SetText("Type /sp for slash commands. Drag the panel itself to move it.")

    -- Sidebar
    local sidebar = CreateFrame("Frame", nil, optionsFrame)
    sidebar:SetWidth(130)
    sidebar:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -12)
    sidebar:SetPoint("BOTTOMLEFT", optionsFrame, "BOTTOMLEFT", 16, 16)

    local divider = optionsFrame:CreateTexture(nil, "ARTWORK")
    divider:SetColorTexture(1, 1, 1, 0.10)
    divider:SetWidth(1)
    divider:SetPoint("TOPLEFT", sidebar, "TOPRIGHT", 6, 0)
    divider:SetPoint("BOTTOMLEFT", sidebar, "BOTTOMRIGHT", 6, 0)

    -- Content area
    local area = CreateFrame("Frame", nil, optionsFrame)
    area:SetPoint("TOPLEFT", sidebar, "TOPRIGHT", 16, 0)
    area:SetPoint("BOTTOMRIGHT", optionsFrame, "BOTTOMRIGHT", -16, 16)

    local tabY = 0
    for _, def in ipairs(PAGES) do
        local scroll, content = UI:ScrollArea(area)
        scroll:SetAllPoints(area)
        content:SetWidth(area:GetWidth() > 0 and (area:GetWidth() - 12) or 440)
        scroll:Hide()

        pages[def.id] = {
            scroll = scroll,
            content = content,
            buildFn = def.build,
            built = false,
        }

        local tab = CreateFrame("Button", nil, sidebar)
        tab:SetHeight(24)
        tab:SetPoint("TOPLEFT", sidebar, "TOPLEFT", 0, -tabY)
        tab:SetPoint("TOPRIGHT", sidebar, "TOPRIGHT", 0, -tabY)

        tab.selected = tab:CreateTexture(nil, "BACKGROUND")
        tab.selected:SetAllPoints(tab)
        tab.selected:SetColorTexture(0.35, 0.55, 0.85, 0.30)
        tab.selected:Hide()

        tab.highlight = tab:CreateTexture(nil, "HIGHLIGHT")
        tab.highlight:SetAllPoints(tab)
        tab.highlight:SetColorTexture(1, 1, 1, 0.08)

        tab.text = tab:CreateFontString(nil, "OVERLAY")
        tab.text:SetFont([[Fonts\FRIZQT__.TTF]], 13, "")
        tab.text:SetPoint("LEFT", tab, "LEFT", 8, 0)
        tab.text:SetText(def.name)

        tab:SetScript("OnClick", function() Options:ShowPage(def.id) end)

        pages[def.id].tab = tab
        tabY = tabY + 26
    end

    -- The canvas gets its real size only once the Settings frame lays it out.
    optionsFrame:SetScript("OnSizeChanged", function()
        local width = area:GetWidth()
        if width and width > 0 then
            for _, page in pairs(pages) do
                page.content:SetWidth(width - 12)
            end
        end
    end)

    optionsFrame:SetScript("OnShow", function()
        Options:ShowPage(currentPage or "general")
        Options:StartPreview()
    end)

    -- Fires when the Settings window closes AND when another category is
    -- selected, which is exactly when the preview should be put away.
    optionsFrame:SetScript("OnHide", function()
        Options:StopPreview()
    end)

    -- Register with the modern Settings API (10.0+).
    --
    -- Deliberately NOT setting category.ID here. Older addon code assigned the
    -- addon name to it so Settings.OpenToCategory("Name") would work, but that
    -- overwrites the numeric ID the category was given at registration, and
    -- OpenSettingsPanel rejects a string with an "outside of expected range"
    -- error. Leave the assigned ID alone and open by that instead.
    local category = Settings.RegisterCanvasLayoutCategory(optionsFrame, "StatPanel")
    Settings.RegisterAddOnCategory(category)
    Options.category = category

    return optionsFrame
end

function SP:OpenOptions()
    SP:CreateOptionsPanel()
    if not (Settings and Settings.OpenToCategory and Options.category) then return end

    local id = Options.category.GetID and Options.category:GetID() or Options.category.ID
    if type(id) == "number" then
        Settings.OpenToCategory(id)
    else
        -- Very old clients took the category name; better than doing nothing.
        Settings.OpenToCategory("StatPanel")
    end
end

-- Backwards-compatible entry point.
function SPAddon_CreateOptionsPanel() return SP:CreateOptionsPanel() end
function SPAddon_UpdateStatPanelVisibility() SP:Refresh() end
