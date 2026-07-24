-- Presets.lua (One-click complete looks)
--
-- A preset is a sparse settings table that gets merged over the active profile.
-- Only the keys a preset actually cares about are listed, so anything it
-- doesn't mention (position, visibility rules, profiles) survives untouched.

local addonName, SP = ...
local L = SP.L

local Presets = {}
SP.Presets = Presets

-- Presets are shown in this order.
Presets.order = {
    -- General looks
    "Modern Bars", "Classic Text", "Compact Bars", "Blizzard", "Transparent",
    "Minimal Mono", "Neon", "Parchment", "Frostbound", "Ember", "Class Colored",
    "Big & Bold", "Ultra Compact", "Terminal",
    -- Matches another addon's styling
    "ElvUI", "ElvUI Transparent",
    -- Role / activity focused
    "Tank", "Healer", "PvP", "Speedrunner", "Raid Ready",
}

Presets.list = {
    --------------------------------------------------------------------------
    ["Modern Bars"] = {
        desc = L["The stock look: flat dark panel with colored stat bars."],
        settings = {
            panel = {
                width = 208, bgTexture = "Solid", bgColor = { 0.04, 0.04, 0.05, 0.90 },
                borderStyle = "Pixel", borderColor = { 1, 1, 1, 0.10 }, borderSize = 1,
                paddingX = 14, paddingTop = 12, paddingBottom = 8, sectionGap = 8,
                headerStep = 20, showTitle = true, titleMode = "ilvl",
                titleFormat = "iLvl $equipped", titleDecimals = 1, titleAlign = "CENTER",
                showDivider = true, autoWidth = false,
            },
            bars = {
                style = "bar", texture = "Flat", height = 15, spacing = 6,
                trackColor = { 0, 0, 0, 0.45 }, borderStyle = "None",
                showLabel = true, showValue = true, showRank = true,
                labelUseStatColor = false, valueUseStatColor = false,
                colorMode = "stat", smooth = true,
            },
            font = {
                face = "Friz Quadrata", shadow = false,
                elements = {
                    title  = { size = 16, flags = "OUTLINE", color = { 0.95, 0.82, 0.32, 1 } },
                    header = { size = 10, flags = "OUTLINE", color = { 0.55, 0.58, 0.62, 1 } },
                    label  = { size = 11, flags = "OUTLINE", color = { 0.80, 0.82, 0.86, 1 } },
                    value  = { size = 11, flags = "OUTLINE", color = { 0.92, 0.92, 0.94, 1 } },
                },
            },
            priorityLine = { enabled = true },
            footer = { enabled = true, showFPS = true },
        },
        sections = {
            { id = "primary",       title = "PRIMARY",       enabled = false, showHeader = true,
              stats = { "Primary", "Strength", "Agility", "Intellect", "Stamina" } },
            { id = "enhancements",  title = "ENHANCEMENTS",  enabled = true, showHeader = true, prioritized = true,
              stats = { "Crit", "Haste", "Mastery", "Versatility" } },
            { id = "defense",       title = "DEFENSE",       enabled = true, showHeader = true,
              stats = { "Armor", "Dodge", "Parry", "Block" } },
            { id = "supplementary", title = "SUPPLEMENTARY", enabled = true, showHeader = true,
              stats = { "Leech", "Avoidance", "Speed" } },
        },
        stats = {
            Primary   = { enabled = false, format = "$value" },
            Crit      = { enabled = true, format = "$value%", decimals = 2 },
            Haste     = { enabled = true, format = "$value%", decimals = 2 },
            Mastery   = { enabled = true, format = "$value%", decimals = 2 },
            Versatility = { enabled = true, format = "$value%", decimals = 2, label = nil },
        },
    },

    --------------------------------------------------------------------------
    -- Text-only readout: one colored line per stat, rating alongside effect,
    -- and an item level header showing equipped vs. overall.
    ["Classic Text"] = {
        desc = L["No bars. One colored line per stat: 'Mastery: 285 - 10.65%'."],
        settings = {
            panel = {
                width = 190, autoWidth = true, minWidth = 150,
                bgTexture = "Solid", bgColor = { 0, 0, 0, 0.55 },
                borderStyle = "None", borderSize = 1, borderColor = { 0, 0, 0, 0 },
                paddingX = 10, paddingTop = 6, paddingBottom = 6,
                sectionGap = 0, headerStep = 0,
                showTitle = true, titleMode = "ilvl",
                titleFormat = "iLvl: $equipped / $overall", titleDecimals = 2,
                titleAlign = "CENTER", showDivider = false,
            },
            bars = {
                style = "text", align = "CENTER", textSep = ": ", textHeight = 15,
                labelUseStatColor = true, valueUseStatColor = true,
                showLabel = true, showValue = true, showRank = false,
            },
            font = {
                face = "Friz Quadrata", shadow = false,
                elements = {
                    title = { size = 13, flags = "OUTLINE", color = { 0.90, 0.90, 0.92, 1 } },
                    label = { size = 12, flags = "OUTLINE", color = { 0.90, 0.90, 0.92, 1 } },
                    value = { size = 12, flags = "OUTLINE", color = { 0.90, 0.90, 0.92, 1 } },
                },
            },
            priorityLine = { enabled = false },
            footer = { enabled = false },
        },
        sections = {
            { id = "primary",       title = "PRIMARY",       enabled = true, showHeader = false,
              stats = { "Primary", "Strength", "Agility", "Intellect", "Stamina" } },
            { id = "enhancements",  title = "ENHANCEMENTS",  enabled = true, showHeader = false, prioritized = true,
              stats = { "Crit", "Haste", "Mastery", "Versatility" } },
            { id = "defense",       title = "DEFENSE",       enabled = false, showHeader = false,
              stats = { "Armor", "Dodge", "Parry", "Block" } },
            { id = "supplementary", title = "SUPPLEMENTARY", enabled = false, showHeader = false,
              stats = { "Leech", "Avoidance", "Speed" } },
        },
        stats = {
            Primary     = { enabled = true,  format = "$value", decimals = 0 },
            Strength    = { enabled = false }, Agility = { enabled = false },
            Intellect   = { enabled = false }, Stamina = { enabled = false },
            Mastery     = { enabled = true, format = "$rating - $value%", decimals = 2 },
            Haste       = { enabled = true, format = "$rating - $value%", decimals = 2 },
            Crit        = { enabled = true, format = "$rating - $value%", decimals = 2 },
            Versatility = { enabled = true, format = "$rating - $value%", decimals = 2, label = "Vers" },
        },
    },

    --------------------------------------------------------------------------
    ["Compact Bars"] = {
        desc = L["Thin headerless bars for a small footprint."],
        settings = {
            panel = {
                width = 170, autoWidth = false,
                bgColor = { 0, 0, 0, 0.65 }, borderStyle = "Pixel",
                borderColor = { 0, 0, 0, 0.9 }, borderSize = 1,
                paddingX = 6, paddingTop = 6, paddingBottom = 4,
                sectionGap = 3, headerStep = 0,
                showTitle = false, showDivider = false,
            },
            bars = {
                style = "bar", texture = "Flat", height = 10, spacing = 2,
                trackColor = { 0, 0, 0, 0.6 }, showRank = false,
                labelUseStatColor = false, valueUseStatColor = false, smooth = true,
            },
            font = {
                face = "Arial Narrow", shadow = true,
                elements = {
                    label = { size = 9, flags = "OUTLINE" },
                    value = { size = 9, flags = "OUTLINE" },
                    footer = { size = 10, flags = "OUTLINE" },
                },
            },
            priorityLine = { enabled = false },
            footer = { enabled = true, showFPS = true },
        },
        sections = {
            { id = "primary",       title = "PRIMARY",       enabled = false, showHeader = false,
              stats = { "Primary", "Strength", "Agility", "Intellect", "Stamina" } },
            { id = "enhancements",  title = "ENHANCEMENTS",  enabled = true, showHeader = false, prioritized = true,
              stats = { "Crit", "Haste", "Mastery", "Versatility" } },
            { id = "defense",       title = "DEFENSE",       enabled = true, showHeader = false,
              stats = { "Armor", "Dodge", "Parry", "Block" } },
            { id = "supplementary", title = "SUPPLEMENTARY", enabled = false, showHeader = false,
              stats = { "Leech", "Avoidance", "Speed" } },
        },
    },

    --------------------------------------------------------------------------
    ["Blizzard"] = {
        desc = L["Blizzard textures and a tooltip border, to match the default UI."],
        settings = {
            panel = {
                width = 220, autoWidth = false,
                bgTexture = "Tooltip", bgColor = { 0.08, 0.08, 0.10, 0.95 },
                borderStyle = "Tooltip", borderColor = { 1, 0.82, 0, 0.85 }, borderSize = 16,
                paddingX = 14, paddingTop = 12, paddingBottom = 8,
                showTitle = true, showDivider = true,
            },
            bars = {
                style = "bar", texture = "Blizzard", height = 16, spacing = 5,
                trackColor = { 0, 0, 0, 0.6 }, borderStyle = "None", smooth = true,
            },
            font = { face = "Friz Quadrata", shadow = true },
            priorityLine = { enabled = true },
            footer = { enabled = true, showFPS = true },
        },
    },

    --------------------------------------------------------------------------
    ["Transparent"] = {
        desc = L["No background or border at all - just floating text and bars."],
        settings = {
            panel = {
                bgColor = { 0, 0, 0, 0 }, borderStyle = "None",
                showDivider = false, autoWidth = false,
            },
            bars = {
                trackColor = { 0, 0, 0, 0.25 }, borderStyle = "None",
            },
            font = { shadow = true },
        },
    },

    --------------------------------------------------------------------------
    -- Thin uppercase text with no chrome at all. Reads like a HUD readout.
    ["Minimal Mono"] = {
        desc = L["Tiny monochrome text, no background. Sits quietly in a corner."],
        settings = {
            panel = {
                width = 160, autoWidth = true, minWidth = 120,
                bgColor = { 0, 0, 0, 0 }, borderStyle = "None",
                paddingX = 4, paddingTop = 4, paddingBottom = 4,
                sectionGap = 0, headerStep = 0,
                showTitle = false, showDivider = false,
            },
            bars = {
                style = "text", align = "LEFT", textSep = " ", textHeight = 13,
                labelUseStatColor = false, valueUseStatColor = false, showRank = false,
            },
            font = {
                face = "Arial Narrow", shadow = true,
                elements = {
                    label  = { size = 11, flags = "OUTLINE", color = { 0.75, 0.75, 0.78, 1 } },
                    value  = { size = 11, flags = "OUTLINE", color = { 0.95, 0.95, 0.97, 1 } },
                    footer = { size = 10, flags = "OUTLINE", color = { 0.6, 0.6, 0.65, 1 } },
                },
            },
            priorityLine = { enabled = false },
            footer = { enabled = true, showFPS = true, colorize = false },
        },
        stats = {
            Crit        = { format = "$value%", decimals = 0 },
            Haste       = { format = "$value%", decimals = 0 },
            Mastery     = { format = "$value%", decimals = 0 },
            Versatility = { format = "$value%", decimals = 0, label = "Vers" },
        },
    },

    --------------------------------------------------------------------------
    ["Neon"] = {
        desc = L["High-contrast glow bars on near-black, with a value gradient."],
        settings = {
            panel = {
                width = 220, autoWidth = false,
                bgTexture = "Solid", bgColor = { 0.02, 0.02, 0.04, 0.92 },
                borderStyle = "Pixel", borderColor = { 0.20, 0.90, 0.95, 0.55 }, borderSize = 1,
                paddingX = 12, paddingTop = 10, paddingBottom = 8,
                sectionGap = 6, headerStep = 18,
                showTitle = true, showDivider = true,
                dividerColor = { 0.20, 0.90, 0.95, 0.35 },
            },
            bars = {
                style = "bar", texture = "Flat", height = 14, spacing = 5,
                trackColor = { 0.06, 0.10, 0.12, 0.85 },
                borderStyle = "Pixel", borderColor = { 0, 0, 0, 0.9 }, borderSize = 1,
                spark = true, sparkColor = { 1, 1, 1, 0.8 },
                smooth = true, smoothSpeed = 12,
                valueUseStatColor = true,
            },
            font = {
                face = "Friz Quadrata", shadow = true,
                elements = {
                    title    = { size = 15, flags = "THICKOUTLINE", color = { 0.20, 0.95, 1.00, 1 } },
                    header   = { size = 10, flags = "OUTLINE", color = { 0.45, 0.85, 0.90, 1 } },
                    label    = { size = 11, flags = "OUTLINE", color = { 0.85, 0.90, 0.95, 1 } },
                    value    = { size = 11, flags = "OUTLINE", color = { 1, 1, 1, 1 } },
                    priority = { size = 10, flags = "OUTLINE", color = { 0.90, 0.40, 0.95, 1 } },
                    footer   = { size = 12, flags = "OUTLINE", color = { 0.20, 0.95, 1.00, 1 } },
                },
            },
            priorityLine = { enabled = true, colorize = true },
            footer = { enabled = true, showFPS = true, showWorldLatency = true },
        },
        stats = {
            Crit        = { color = { 1.00, 0.20, 0.45, 1 } },
            Haste       = { color = { 1.00, 0.85, 0.15, 1 } },
            Mastery     = { color = { 0.25, 1.00, 0.55, 1 } },
            Versatility = { color = { 0.30, 0.65, 1.00, 1 } },
        },
    },

    --------------------------------------------------------------------------
    ["Parchment"] = {
        desc = L["Warm parchment and gold, in keeping with the default UI art."],
        settings = {
            panel = {
                width = 230, autoWidth = false,
                bgTexture = "Marble", bgColor = { 0.85, 0.75, 0.55, 0.95 },
                borderStyle = "Gold", borderColor = { 1, 1, 1, 1 }, borderSize = 32,
                paddingX = 18, paddingTop = 14, paddingBottom = 12,
                sectionGap = 6, headerStep = 18,
                showTitle = true, showDivider = true,
                dividerColor = { 0.35, 0.25, 0.10, 0.45 },
            },
            bars = {
                style = "bar", texture = "Blizzard Skills", height = 14, spacing = 5,
                trackColor = { 0.25, 0.18, 0.10, 0.55 },
                borderStyle = "None", smooth = true,
            },
            font = {
                face = "Morpheus", shadow = false,
                elements = {
                    title    = { size = 16, flags = "", color = { 0.30, 0.18, 0.05, 1 } },
                    header   = { size = 11, flags = "", color = { 0.40, 0.28, 0.12, 1 } },
                    label    = { size = 12, flags = "", color = { 0.20, 0.13, 0.05, 1 } },
                    value    = { size = 12, flags = "", color = { 0.15, 0.10, 0.03, 1 } },
                    priority = { size = 10, flags = "", color = { 0.45, 0.30, 0.10, 1 } },
                    footer   = { size = 12, flags = "", color = { 0.30, 0.18, 0.05, 1 } },
                },
            },
            priorityLine = { enabled = true },
            footer = { enabled = true, showFPS = true, colorize = false },
        },
    },

    --------------------------------------------------------------------------
    -- Role presets: these mainly change WHICH stats are on show.
    ["Tank"] = {
        desc = L["Defensive focus: armor, dodge, parry, block and avoidance up top."],
        settings = {
            panel = { width = 215, autoWidth = false, showTitle = true },
            bars = { style = "bar", height = 15, spacing = 5, smooth = true },
            priorityLine = { enabled = true },
            footer = { enabled = true, showFPS = true },
        },
        sections = {
            { id = "defense",       title = "MITIGATION",   enabled = true, showHeader = true,
              stats = { "Armor", "Dodge", "Parry", "Block" } },
            { id = "supplementary", title = "AVOIDANCE",    enabled = true, showHeader = true,
              stats = { "Avoidance", "Leech", "Speed" } },
            { id = "enhancements",  title = "SECONDARY",    enabled = true, showHeader = true, prioritized = true,
              stats = { "Crit", "Haste", "Mastery", "Versatility" } },
            { id = "primary",       title = "ATTRIBUTES",   enabled = true, showHeader = true,
              stats = { "Stamina", "Primary", "Strength", "Agility", "Intellect" } },
        },
        stats = {
            Parry     = { enabled = true }, Block = { enabled = true },
            Armor     = { enabled = true, format = "$value%" },
            Stamina   = { enabled = true, format = "$valuec" },
            Primary   = { enabled = false },
            Strength  = { enabled = false }, Agility = { enabled = false }, Intellect = { enabled = false },
        },
    },

    --------------------------------------------------------------------------
    ["Speedrunner"] = {
        desc = L["Big live speed readout with your session record, and little else."],
        settings = {
            panel = {
                width = 190, autoWidth = true, minWidth = 150,
                bgColor = { 0, 0, 0, 0.5 }, borderStyle = "None",
                paddingX = 10, paddingTop = 6, paddingBottom = 6,
                sectionGap = 0, headerStep = 0,
                showTitle = false, showDivider = false,
            },
            bars = {
                style = "text", align = "CENTER", textSep = ": ", textHeight = 18,
                labelUseStatColor = true, valueUseStatColor = true, showRank = false,
            },
            font = {
                face = "Friz Quadrata", shadow = true,
                elements = {
                    label  = { size = 15, flags = "OUTLINE", color = { 0.95, 0.72, 0.38, 1 } },
                    value  = { size = 15, flags = "OUTLINE", color = { 1, 1, 1, 1 } },
                    footer = { size = 11, flags = "OUTLINE" },
                },
            },
            priorityLine = { enabled = false },
            footer = { enabled = true, showFPS = true },
        },
        sections = {
            { id = "supplementary", title = "SPEED", enabled = true, showHeader = false,
              stats = { "Speed", "Avoidance", "Leech" } },
            { id = "enhancements",  title = "SECONDARY", enabled = false, showHeader = false, prioritized = true,
              stats = { "Crit", "Haste", "Mastery", "Versatility" } },
            { id = "defense",       title = "DEFENSE", enabled = false, showHeader = false,
              stats = { "Armor", "Dodge", "Parry", "Block" } },
            { id = "primary",       title = "PRIMARY", enabled = false, showHeader = false,
              stats = { "Primary", "Strength", "Agility", "Intellect", "Stamina" } },
        },
        stats = {
            Speed     = { enabled = true, format = "$value%  (peak $peak%)", decimals = 0, autoMax = true },
            Avoidance = { enabled = false }, Leech = { enabled = false },
        },
    },

    --------------------------------------------------------------------------
    ["Raid Ready"] = {
        desc = L["Secondary stats, item level and both latencies - what you check before a pull."],
        settings = {
            panel = {
                width = 225, autoWidth = false,
                bgColor = { 0.03, 0.03, 0.05, 0.88 },
                borderStyle = "Pixel", borderColor = { 1, 1, 1, 0.12 }, borderSize = 1,
                paddingX = 12, paddingTop = 10, paddingBottom = 8,
                sectionGap = 5, headerStep = 17,
                showTitle = true, titleMode = "ilvl",
                titleFormat = "iLvl $equipped / $overall", titleDecimals = 1,
                showDivider = true,
            },
            bars = {
                style = "bar", texture = "Flat", height = 13, spacing = 4,
                smooth = true, showRank = true,
            },
            font = {
                face = "Friz Quadrata", shadow = false,
                elements = {
                    title  = { size = 14, flags = "OUTLINE", color = { 0.95, 0.82, 0.32, 1 } },
                    label  = { size = 11, flags = "OUTLINE" },
                    value  = { size = 11, flags = "OUTLINE" },
                    footer = { size = 12, flags = "OUTLINE" },
                },
            },
            priorityLine = { enabled = true, showSpec = true },
            footer = {
                enabled = true, showFPS = true,
                showHomeLatency = true, showWorldLatency = true,
                colorize = true,
            },
        },
        sections = {
            { id = "enhancements",  title = "SECONDARY", enabled = true, showHeader = true, prioritized = true,
              stats = { "Crit", "Haste", "Mastery", "Versatility" } },
            { id = "supplementary", title = "UTILITY",   enabled = true, showHeader = true,
              stats = { "Leech", "Avoidance", "Speed" } },
            { id = "defense",       title = "DEFENSE",   enabled = false, showHeader = true,
              stats = { "Armor", "Dodge", "Parry", "Block" } },
            { id = "primary",       title = "PRIMARY",   enabled = false, showHeader = true,
              stats = { "Primary", "Strength", "Agility", "Intellect", "Stamina" } },
        },
    },

    --------------------------------------------------------------------------
    ["Frostbound"] = {
        desc = L["Cold blues and whites on deep navy."],
        settings = {
            panel = {
                width = 210, autoWidth = false,
                bgTexture = "Solid", bgColor = { 0.04, 0.07, 0.12, 0.92 },
                borderStyle = "Pixel", borderColor = { 0.45, 0.75, 0.95, 0.45 }, borderSize = 1,
                paddingX = 12, paddingTop = 10, paddingBottom = 8,
                sectionGap = 6, headerStep = 18,
                showTitle = true, showDivider = true,
                dividerColor = { 0.45, 0.75, 0.95, 0.30 },
            },
            bars = {
                style = "bar", texture = "Flat", height = 14, spacing = 5,
                trackColor = { 0.02, 0.05, 0.09, 0.85 }, smooth = true,
            },
            font = {
                face = "Friz Quadrata", shadow = true,
                elements = {
                    title    = { size = 15, flags = "OUTLINE", color = { 0.75, 0.92, 1.00, 1 } },
                    header   = { size = 10, flags = "OUTLINE", color = { 0.45, 0.65, 0.80, 1 } },
                    label    = { size = 11, flags = "OUTLINE", color = { 0.80, 0.90, 0.97, 1 } },
                    value    = { size = 11, flags = "OUTLINE", color = { 1, 1, 1, 1 } },
                    priority = { size = 10, flags = "OUTLINE", color = { 0.55, 0.80, 0.95, 1 } },
                    footer   = { size = 12, flags = "OUTLINE", color = { 0.65, 0.85, 1.00, 1 } },
                },
            },
        },
        stats = {
            Crit        = { color = { 0.55, 0.85, 1.00, 1 } },
            Haste       = { color = { 0.75, 0.95, 1.00, 1 } },
            Mastery     = { color = { 0.35, 0.60, 0.95, 1 } },
            Versatility = { color = { 0.50, 0.70, 0.90, 1 } },
        },
    },

    --------------------------------------------------------------------------
    ["Ember"] = {
        desc = L["Warm reds and ambers on charcoal."],
        settings = {
            panel = {
                width = 210, autoWidth = false,
                bgTexture = "Solid", bgColor = { 0.10, 0.05, 0.03, 0.92 },
                borderStyle = "Pixel", borderColor = { 0.95, 0.55, 0.20, 0.45 }, borderSize = 1,
                paddingX = 12, paddingTop = 10, paddingBottom = 8,
                sectionGap = 6, headerStep = 18,
                showTitle = true, showDivider = true,
                dividerColor = { 0.95, 0.55, 0.20, 0.30 },
            },
            bars = {
                style = "bar", texture = "Flat", height = 14, spacing = 5,
                trackColor = { 0.06, 0.03, 0.02, 0.85 }, smooth = true,
            },
            font = {
                face = "Friz Quadrata", shadow = true,
                elements = {
                    title    = { size = 15, flags = "OUTLINE", color = { 1.00, 0.75, 0.40, 1 } },
                    header   = { size = 10, flags = "OUTLINE", color = { 0.70, 0.45, 0.25, 1 } },
                    label    = { size = 11, flags = "OUTLINE", color = { 0.95, 0.85, 0.75, 1 } },
                    value    = { size = 11, flags = "OUTLINE", color = { 1, 1, 1, 1 } },
                    priority = { size = 10, flags = "OUTLINE", color = { 0.95, 0.60, 0.30, 1 } },
                    footer   = { size = 12, flags = "OUTLINE", color = { 1.00, 0.70, 0.35, 1 } },
                },
            },
        },
        stats = {
            Crit        = { color = { 1.00, 0.30, 0.20, 1 } },
            Haste       = { color = { 1.00, 0.70, 0.20, 1 } },
            Mastery     = { color = { 0.90, 0.45, 0.15, 1 } },
            Versatility = { color = { 0.75, 0.35, 0.25, 1 } },
        },
    },

    --------------------------------------------------------------------------
    ["Class Colored"] = {
        desc = L["Every bar takes your class color. Clean and unfussy."],
        settings = {
            panel = {
                width = 200, autoWidth = false,
                bgColor = { 0.05, 0.05, 0.06, 0.85 },
                borderStyle = "Pixel", borderColor = { 1, 1, 1, 0.12 }, borderSize = 1,
                paddingX = 10, paddingTop = 8, paddingBottom = 6,
                sectionGap = 4, headerStep = 0,
                showTitle = true, showDivider = false,
            },
            bars = {
                style = "bar", texture = "Flat", height = 13, spacing = 4,
                colorMode = "class", trackColor = { 0, 0, 0, 0.55 },
                showRank = false, smooth = true,
            },
            font = {
                face = "Friz Quadrata", shadow = true,
                elements = {
                    title = { size = 14, flags = "OUTLINE" },
                    label = { size = 11, flags = "OUTLINE" },
                    value = { size = 11, flags = "OUTLINE" },
                },
            },
            priorityLine = { enabled = false },
            footer = { enabled = true, showFPS = true },
        },
    },

    --------------------------------------------------------------------------
    -- Deliberately oversized and high contrast, for readability at a distance
    -- or on a large display.
    ["Big & Bold"] = {
        desc = L["Large, heavy, high-contrast text. Easy to read at a glance."],
        settings = {
            panel = {
                width = 300, autoWidth = true, minWidth = 260,
                bgColor = { 0, 0, 0, 0.80 },
                borderStyle = "Pixel", borderColor = { 1, 1, 1, 0.30 }, borderSize = 2,
                paddingX = 14, paddingTop = 12, paddingBottom = 10,
                sectionGap = 8, headerStep = 24,
                showTitle = true, showDivider = true,
            },
            bars = {
                style = "bar", texture = "Flat", height = 24, spacing = 7,
                trackColor = { 0, 0, 0, 0.7 }, smooth = true,
                valueUseStatColor = false,
            },
            font = {
                face = "Friz Quadrata", shadow = true,
                elements = {
                    title    = { size = 22, flags = "THICKOUTLINE", color = { 1, 0.85, 0.35, 1 } },
                    header   = { size = 14, flags = "THICKOUTLINE", color = { 0.80, 0.82, 0.86, 1 } },
                    label    = { size = 16, flags = "THICKOUTLINE", color = { 1, 1, 1, 1 } },
                    value    = { size = 16, flags = "THICKOUTLINE", color = { 1, 1, 1, 1 } },
                    priority = { size = 13, flags = "THICKOUTLINE", color = { 0.70, 0.82, 1.00, 1 } },
                    footer   = { size = 16, flags = "THICKOUTLINE", color = { 1, 1, 1, 1 } },
                },
            },
            priorityLine = { enabled = true },
            footer = { enabled = true, showFPS = true },
        },
    },

    --------------------------------------------------------------------------
    ["Ultra Compact"] = {
        desc = L["The smallest useful readout: four secondaries, nothing else."],
        settings = {
            panel = {
                width = 120, autoWidth = true, minWidth = 90,
                bgColor = { 0, 0, 0, 0.55 }, borderStyle = "None",
                paddingX = 5, paddingTop = 3, paddingBottom = 3,
                sectionGap = 0, headerStep = 0,
                showTitle = false, showDivider = false,
            },
            bars = {
                style = "text", align = "LEFT", textSep = " ", textHeight = 11,
                labelUseStatColor = true, valueUseStatColor = true, showRank = false,
            },
            font = {
                face = "Arial Narrow", shadow = true,
                elements = {
                    label = { size = 10, flags = "OUTLINE" },
                    value = { size = 10, flags = "OUTLINE" },
                },
            },
            priorityLine = { enabled = false },
            footer = { enabled = false },
        },
        sections = {
            { id = "enhancements",  title = "SECONDARY", enabled = true, showHeader = false, prioritized = true,
              stats = { "Crit", "Haste", "Mastery", "Versatility" } },
            { id = "primary",       title = "PRIMARY",   enabled = false, showHeader = false,
              stats = { "Primary", "Strength", "Agility", "Intellect", "Stamina" } },
            { id = "defense",       title = "DEFENSE",   enabled = false, showHeader = false,
              stats = { "Armor", "Dodge", "Parry", "Block" } },
            { id = "supplementary", title = "UTILITY",   enabled = false, showHeader = false,
              stats = { "Leech", "Avoidance", "Speed" } },
        },
        stats = {
            Crit        = { format = "$value", decimals = 0, label = "C" },
            Haste       = { format = "$value", decimals = 0, label = "H" },
            Mastery     = { format = "$value", decimals = 0, label = "M" },
            Versatility = { format = "$value", decimals = 0, label = "V" },
        },
    },

    --------------------------------------------------------------------------
    ["Terminal"] = {
        desc = L["Green-on-black monospace, like a console readout."],
        settings = {
            panel = {
                width = 200, autoWidth = true, minWidth = 170,
                bgTexture = "Solid", bgColor = { 0, 0.02, 0, 0.90 },
                borderStyle = "Pixel", borderColor = { 0.20, 0.90, 0.30, 0.5 }, borderSize = 1,
                paddingX = 8, paddingTop = 6, paddingBottom = 6,
                sectionGap = 2, headerStep = 14,
                showTitle = true, titleMode = "ilvl",
                titleFormat = "> ilvl $equipped", titleDecimals = 1, titleAlign = "LEFT",
                showDivider = false,
            },
            bars = {
                style = "text", align = "LEFT", textSep = " = ", textHeight = 13,
                labelUseStatColor = false, valueUseStatColor = false, showRank = false,
            },
            font = {
                face = "Arial Narrow", shadow = false,
                elements = {
                    title  = { size = 12, flags = "MONOCHROME", color = { 0.30, 1.00, 0.40, 1 } },
                    header = { size = 10, flags = "MONOCHROME", color = { 0.15, 0.55, 0.20, 1 } },
                    label  = { size = 12, flags = "MONOCHROME", color = { 0.25, 0.85, 0.35, 1 } },
                    value  = { size = 12, flags = "MONOCHROME", color = { 0.55, 1.00, 0.60, 1 } },
                    footer = { size = 11, flags = "MONOCHROME", color = { 0.20, 0.70, 0.28, 1 } },
                },
            },
            priorityLine = { enabled = false },
            footer = { enabled = true, showFPS = true, colorize = false },
        },
        stats = {
            Crit        = { format = "$value%", decimals = 1 },
            Haste       = { format = "$value%", decimals = 1 },
            Mastery     = { format = "$value%", decimals = 1 },
            Versatility = { format = "$value%", decimals = 1, label = "Vers" },
        },
    },

    --------------------------------------------------------------------------
    ["Healer"] = {
        desc = L["Throughput stats plus leech, with your primary attribute on top."],
        settings = {
            panel = { width = 215, autoWidth = false, showTitle = true, showDivider = true },
            bars = { style = "bar", height = 15, spacing = 5, smooth = true },
            priorityLine = { enabled = true },
            footer = { enabled = true, showFPS = true, showWorldLatency = true },
        },
        sections = {
            { id = "primary",       title = "POWER",     enabled = true, showHeader = true,
              stats = { "Primary", "Strength", "Agility", "Intellect", "Stamina" } },
            { id = "enhancements",  title = "SECONDARY", enabled = true, showHeader = true, prioritized = true,
              stats = { "Crit", "Haste", "Mastery", "Versatility" } },
            { id = "supplementary", title = "UTILITY",   enabled = true, showHeader = true,
              stats = { "Leech", "Speed", "Avoidance" } },
            { id = "defense",       title = "DEFENSE",   enabled = false, showHeader = true,
              stats = { "Armor", "Dodge", "Parry", "Block" } },
        },
        stats = {
            Primary   = { enabled = true, format = "$valuec" },
            Strength  = { enabled = false }, Agility = { enabled = false },
            Intellect = { enabled = false }, Stamina = { enabled = false },
            Leech     = { enabled = true }, Speed = { enabled = true },
            Avoidance = { enabled = false },
        },
    },

    --------------------------------------------------------------------------
    ["PvP"] = {
        desc = L["Versatility first, with avoidance, dodge and speed alongside."],
        settings = {
            panel = {
                width = 210, autoWidth = false,
                bgColor = { 0.06, 0.02, 0.02, 0.88 },
                borderStyle = "Pixel", borderColor = { 0.85, 0.25, 0.25, 0.5 }, borderSize = 1,
                showTitle = true, showDivider = true,
            },
            bars = { style = "bar", height = 15, spacing = 5, smooth = true },
            priorityLine = { enabled = true, showSpec = false },
            footer = { enabled = true, showFPS = true, showWorldLatency = true },
        },
        sections = {
            { id = "enhancements",  title = "SECONDARY",  enabled = true, showHeader = true, prioritized = false,
              stats = { "Versatility", "Crit", "Haste", "Mastery" } },
            { id = "supplementary", title = "SURVIVAL",   enabled = true, showHeader = true,
              stats = { "Speed", "Leech", "Avoidance" } },
            { id = "defense",       title = "MITIGATION", enabled = true, showHeader = true,
              stats = { "Dodge", "Parry", "Armor", "Block" } },
            { id = "primary",       title = "PRIMARY",    enabled = false, showHeader = true,
              stats = { "Primary", "Strength", "Agility", "Intellect", "Stamina" } },
        },
        stats = {
            Versatility = { enabled = true, color = { 0.95, 0.85, 0.30, 1 } },
            Parry       = { enabled = true }, Block = { enabled = false },
        },
    },

    --------------------------------------------------------------------------
    -- ElvUI styling: flat dark backdrop, hairline black border, narrow font.
    --
    -- ElvUI registers its media with LibSharedMedia, so naming "ElvUI Norm" and
    -- "PT Sans Narrow" resolves to the real assets when it's installed and
    -- silently falls back to our built-ins when it isn't. The `dynamic` hook
    -- below then matches your actual configured ElvUI colors.
    ["ElvUI"] = {
        desc = L["Matches ElvUI: flat dark panel, 1px black border, narrow font."],
        settings = {
            panel = {
                width = 200, autoWidth = false,
                bgTexture = "Solid", bgColor = { 0.10, 0.10, 0.10, 0.90 },
                borderStyle = "Pixel", borderColor = { 0, 0, 0, 1 }, borderSize = 1,
                paddingX = 8, paddingTop = 7, paddingBottom = 6,
                sectionGap = 4, headerStep = 15,
                showTitle = true, titleMode = "ilvl",
                titleFormat = "iLvl $equipped", titleDecimals = 1, titleAlign = "CENTER",
                showDivider = true, dividerColor = { 0, 0, 0, 0.8 },
            },
            bars = {
                style = "bar", texture = "ElvUI Norm", height = 13, spacing = 3,
                trackColor = { 0.06, 0.06, 0.06, 0.85 },
                borderStyle = "Pixel", borderColor = { 0, 0, 0, 1 }, borderSize = 1,
                smooth = true, smoothSpeed = 10, showRank = false,
            },
            font = {
                face = "PT Sans Narrow", shadow = false,
                elements = {
                    title    = { size = 12, flags = "OUTLINE", color = { 1, 1, 1, 1 } },
                    header   = { size = 10, flags = "OUTLINE", color = { 0.60, 0.60, 0.60, 1 } },
                    label    = { size = 12, flags = "OUTLINE", color = { 1, 1, 1, 1 } },
                    value    = { size = 12, flags = "OUTLINE", color = { 1, 1, 1, 1 } },
                    priority = { size = 11, flags = "OUTLINE", color = { 0.75, 0.75, 0.75, 1 } },
                    footer   = { size = 12, flags = "OUTLINE", color = { 1, 1, 1, 1 } },
                },
            },
            priorityLine = { enabled = true },
            footer = { enabled = true, showFPS = true, showWorldLatency = true },
        },
        dynamic = function() SP.Presets:ApplyElvUITheme(false) end,
    },

    --------------------------------------------------------------------------
    ["ElvUI Transparent"] = {
        desc = L["The popular transparent ElvUI style: near-black glass, hairline border."],
        settings = {
            panel = {
                width = 200, autoWidth = false,
                bgTexture = "Solid", bgColor = { 0, 0, 0, 0.55 },
                borderStyle = "Pixel", borderColor = { 0, 0, 0, 1 }, borderSize = 1,
                paddingX = 8, paddingTop = 7, paddingBottom = 6,
                sectionGap = 4, headerStep = 15,
                showTitle = true, titleMode = "ilvl",
                titleFormat = "iLvl $equipped", titleDecimals = 1, titleAlign = "CENTER",
                showDivider = false,
            },
            bars = {
                style = "bar", texture = "ElvUI Norm", height = 13, spacing = 3,
                trackColor = { 0, 0, 0, 0.45 },
                borderStyle = "Pixel", borderColor = { 0, 0, 0, 1 }, borderSize = 1,
                smooth = true, smoothSpeed = 10, showRank = false,
            },
            font = {
                face = "PT Sans Narrow", shadow = true,
                elements = {
                    title    = { size = 12, flags = "OUTLINE", color = { 1, 1, 1, 1 } },
                    header   = { size = 10, flags = "OUTLINE", color = { 0.65, 0.65, 0.65, 1 } },
                    label    = { size = 12, flags = "OUTLINE", color = { 1, 1, 1, 1 } },
                    value    = { size = 12, flags = "OUTLINE", color = { 1, 1, 1, 1 } },
                    priority = { size = 11, flags = "OUTLINE", color = { 0.75, 0.75, 0.75, 1 } },
                    footer   = { size = 12, flags = "OUTLINE", color = { 1, 1, 1, 1 } },
                },
            },
            priorityLine = { enabled = true },
            footer = { enabled = true, showFPS = true, showWorldLatency = true },
        },
        dynamic = function() SP.Presets:ApplyElvUITheme(true) end,
    },
}

--------------------------------------------------------------------------------
-- ELVUI INTEGRATION
--------------------------------------------------------------------------------
-- Returns ElvUI's main engine table, or nil when it isn't loaded.
local function getElvUI()
    if type(_G.ElvUI) ~= "table" then return nil end
    local ok, E = pcall(function() return unpack(_G.ElvUI) end)
    if ok and type(E) == "table" then return E end
    return nil
end

-- ElvUI stores colors as either {r,g,b} arrays or {r=,g=,b=} tables.
local function readColor(source, alpha)
    if type(source) ~= "table" then return nil end
    local r = source.r or source[1]
    local g = source.g or source[2]
    local b = source.b or source[3]
    if type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" then return nil end
    return { r, g, b, alpha or source.a or source[4] or 1 }
end

-- Prefers a shared-media NAME over a raw path so the options dropdowns show
-- something readable, falling back to the path when the name isn't registered.
local function preferName(kind, name, path)
    for _, registered in ipairs(SP.Media:List(kind)) do
        if registered == name then return name end
    end
    return path or name
end

-- Copies the live ElvUI theme onto the current profile. Everything is optional
-- and individually guarded: if ElvUI is absent or a field has moved, the
-- preset's static values simply stand.
function Presets:ApplyElvUITheme(transparent)
    local E = getElvUI()
    if not E then return false end

    local db = SP.db
    local media = type(E.media) == "table" and E.media or {}

    if type(media.normTex) == "string" then
        db.bars.texture = preferName("statusbar", "ElvUI Norm", media.normTex)
    end
    if type(media.normFont) == "string" then
        db.font.face = preferName("font", "PT Sans Narrow", media.normFont)
    end

    local border = readColor(media.bordercolor, 1)
    if border then
        db.panel.borderColor = border
        db.bars.borderColor = { border[1], border[2], border[3], 1 }
        db.panel.dividerColor = { border[1], border[2], border[3], 0.8 }
    end

    -- ElvUI keeps a separate faded color for its transparent style.
    local backdrop = transparent
        and (readColor(media.backdropfadecolor) or readColor(media.backdropcolor, 0.55))
        or readColor(media.backdropcolor, 0.9)
    if backdrop then
        db.panel.bgColor = backdrop
        db.bars.trackColor = { backdrop[1], backdrop[2], backdrop[3], transparent and 0.45 or 0.85 }
    end

    local fontSize = E.db and E.db.general and tonumber(E.db.general.fontSize)
    if fontSize and fontSize >= 6 and fontSize <= 32 then
        for _, element in pairs(db.font.elements) do
            element.size = fontSize
        end
        db.font.elements.header.size = math.max(6, fontSize - 2)
        db.font.elements.priority.size = math.max(6, fontSize - 1)
    end

    return true
end

-- Merges a sparse preset table into a live settings table.
local function overlay(dst, src)
    for k, v in pairs(src) do
        if type(v) == "table" and type(dst[k]) == "table" and not v[1] then
            overlay(dst[k], v)
        else
            dst[k] = SP.Config:DeepCopy(v)
        end
    end
end

-- Panel keys that are the user's context, not the preset's look: where the
-- window sits, how it stacks and behaves, and when it is allowed to show. A
-- preset switch must leave every one of these alone. Everything else under
-- `panel` (colors, sizes, title, borders) is look and gets reset.
local PRESERVE_PANEL = {
    pos = true, locked = true, clamp = true, strata = true, frameLevel = true,
    tooltips = true,
    hideInCombat = true, onlyInCombat = true, hideInVehicle = true,
    hideInPetBattle = true, hideWhenDead = true, hideInInstance = true,
    hideOutOfInstance = true, mouseoverOnly = true, fadeAlpha = true,
    fadeDuration = true,
}

-- A preset is a *sparse* table, so applying one over whatever look was there
-- before leaves behind any key the new preset doesn't mention -- switch away
-- from Neon and its spark, fast smoothing and pink crit bar stay. Presets bill
-- themselves as complete looks, so reset the look to defaults first, preserving
-- only the user's position, visibility rules and account prefs.
local function resetLook()
    local D = SP.Config.DEFAULTS
    local function dc(v) return SP.Config:DeepCopy(v) end

    for k, v in pairs(D.panel) do
        if not PRESERVE_PANEL[k] then SP.db.panel[k] = dc(v) end
    end

    SP.db.bars        = dc(D.bars)
    SP.db.font        = dc(D.font)
    SP.db.stats       = dc(D.stats)
    SP.db.sections    = dc(D.sections)
    SP.db.footer      = dc(D.footer)
    SP.db.valueSource = D.valueSource
end

function Presets:Apply(name)
    local preset = self.list[name]
    if not preset then return false end

    resetLook()
    overlay(SP.db, preset.settings)

    -- Sections and per-stat overrides are applied separately: sections replace
    -- the whole list (order matters), stats merge key by key.
    if preset.sections then
        SP.db.sections = SP.Config:DeepCopy(preset.sections)
    end
    if preset.stats then
        for statName, override in pairs(preset.stats) do
            SP.db.stats[statName] = SP.db.stats[statName] or {}
            for k, v in pairs(override) do
                -- Deep-copy: a raw assignment would alias the preset's own color
                -- table into the profile, so two profiles on the same preset --
                -- and the in-memory preset itself -- would share one table and
                -- mutate together.
                SP.db.stats[statName][k] = SP.Config:DeepCopy(v)
            end
        end
    end

    -- Last, so a preset can adapt to what's actually installed. Guarded: a
    -- broken hook must not leave the profile half-applied.
    if preset.dynamic then
        local ok, err = pcall(preset.dynamic)
        if not ok then SP:Print(L["preset hook failed: %s"]:format(tostring(err))) end
    end

    SP:Refresh()
    return true
end
