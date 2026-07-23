-- Config.lua (Saved variables, defaults, profiles, import/export)
--
-- SPAddonDB layout:
--   SPAddonDB.profiles[name]  -- one settings table per profile
--   SPAddonDB.chars[charKey]  -- which profile each character uses
--   SPAddonDB.global          -- settings that never vary per profile
--
-- Everything the panel draws is read out of the active profile, so adding a new
-- option here is all it takes for it to become customizable: StatPanel.lua
-- re-reads the whole profile on every refresh.

local addonName, SP = ...

local Config = {}
SP.Config = Config

local DB_VERSION = 2

--------------------------------------------------------------------------------
-- DEFAULTS
--------------------------------------------------------------------------------
-- Per-stat display defaults.
--
-- `format` is a token template rather than a printf string, so a stat can show
-- its rating and its effect together. Supported tokens:
--   $value   the stat's headline number (a percentage for rated stats)
--   $rating  the raw combat rating behind it (0 for stats that have none)
--   $max     the configured bar maximum
--   $label   the stat's display name
-- e.g. "$rating - $value%" renders as "285 - 10.65%".
--
-- `fill` controls how the bar body is drawn (bar style only):
--   "value" - fill proportional to value/max
--   "full"  - always full (use it as a colored plate behind the text)
--   "none"  - track only, text on top
local function statDefaults(color, format, max, decimals, fill, enabled)
    return {
        enabled  = enabled ~= false,
        color    = color,
        format   = format,
        decimals = decimals or 0,
        max      = max,
        autoMax  = false,  -- grow `max` to the highest value seen this session
        fill     = fill or "value",
        label    = nil,   -- nil = use the built-in name
        useClassColor = false,
    }
end

local DEFAULTS = {
    enabled = true,
    updateInterval = 0.1,

    -- "total" shows what the character sheet shows (base + rating + buffs).
    -- "bonus" shows only the contribution the rating itself is providing.
    valueSource = "total",

    panel = {
        width        = 208,
        autoWidth    = false,          -- size to the widest row instead of `width`
        minWidth     = 120,
        scale        = 1.0,
        alpha        = 1.0,
        strata       = "MEDIUM",
        frameLevel   = 10,
        locked       = false,
        clamp        = true,
        pos          = { point = "CENTER", relPoint = "CENTER", x = 300, y = 0 },

        paddingX      = 14,
        paddingTop    = 12,
        paddingBottom = 8,
        sectionGap    = 8,
        headerStep    = 20,
        headerAlign   = "LEFT",

        bgTexture    = "Solid",
        bgColor      = { 0.04, 0.04, 0.05, 0.90 },
        bgTile       = false,
        bgTileSize   = 32,

        borderStyle  = "Pixel",
        borderColor  = { 1, 1, 1, 0.10 },
        borderSize   = 1,
        borderInset  = 0,

        showTitle    = true,
        titleMode    = "ilvl",         -- ilvl | name | spec | custom | none
        titleText    = "StatPanel",
        -- Title tokens: $equipped, $overall, $name, $spec, $class, $level
        titleFormat  = "iLvl $equipped",
        titleDecimals = 1,
        titleAlign   = "CENTER",
        showDivider  = true,
        dividerColor = { 1, 1, 1, 0.08 },
        dividerThickness = 1,

        -- Visibility conditions
        hideInCombat    = false,
        onlyInCombat    = false,
        hideInVehicle   = false,
        hideInPetBattle = true,
        hideWhenDead    = false,
        hideInInstance  = false,
        hideOutOfInstance = false,

        -- Mouseover fading
        mouseoverOnly = false,
        fadeAlpha     = 0.0,
        fadeDuration  = 0.25,

        tooltips = true,
    },

    -- Row appearance. `style` picks how every stat row is drawn:
    --   "bar"  - a status bar with the label on the left and value on the right
    --   "text" - a single line of text ("Mastery: 285 - 10.65%"), no bar at all
    -- The keys below that mention bars are ignored in text style, and vice versa.
    bars = {
        style        = "bar",
        align        = "LEFT",          -- text style row alignment
        textSep      = ": ",            -- joins label and value in text style
        textHeight   = 15,              -- row step in text style
        texture      = "Flat",
        height       = 15,
        spacing      = 6,
        inset        = 0,
        trackTexture = "Solid",
        trackColor   = { 0, 0, 0, 0.45 },
        trackUseStatColor = false,
        trackStatAlpha    = 0.15,

        borderStyle  = "None",
        borderColor  = { 0, 0, 0, 1 },
        borderSize   = 1,

        reverseFill  = false,
        orientation  = "HORIZONTAL",
        smooth       = true,
        smoothSpeed  = 8,
        spark        = false,
        sparkColor   = { 1, 1, 1, 0.55 },
        alpha        = 1.0,

        colorMode    = "stat",         -- stat | class | single | gradient
        singleColor  = { 0.35, 0.60, 0.90, 1 },
        gradientLow  = { 0.90, 0.25, 0.25, 1 },
        gradientHigh = { 0.35, 0.85, 0.40, 1 },

        showLabel        = true,
        showValue        = true,
        labelX           = 5,
        valueX           = -5,
        labelUseStatColor = false,
        valueUseStatColor = false,
        showRank         = true,
        rankFormat       = "%d  ",
    },

    font = {
        face        = "Friz Quadrata",
        shadow      = false,
        shadowColor = { 0, 0, 0, 1 },
        shadowX     = 1,
        shadowY     = -1,
        elements = {
            title    = { size = 16, flags = "OUTLINE", color = { 0.95, 0.82, 0.32, 1 } },
            header   = { size = 10, flags = "OUTLINE", color = { 0.55, 0.58, 0.62, 1 } },
            label    = { size = 11, flags = "OUTLINE", color = { 0.80, 0.82, 0.86, 1 } },
            value    = { size = 11, flags = "OUTLINE", color = { 0.92, 0.92, 0.94, 1 } },
            priority = { size = 10, flags = "OUTLINE", color = { 0.60, 0.72, 0.90, 1 } },
            footer   = { size = 13, flags = "OUTLINE", color = { 1, 1, 1, 1 } },
        },
    },

    priorityLine = {
        enabled   = true,
        separator = " > ",
        colorize  = false,
        showSpec  = false,
    },

    footer = {
        enabled         = true,
        showFPS         = true,
        showHomeLatency = false,
        showWorldLatency= false,
        showMemory      = false,
        fpsFormat       = "%.0f fps",
        homeFormat      = "%d ms",
        worldFormat     = "%d ms",
        memoryFormat    = "%.1f mb",
        separator       = "  |  ",
        colorize        = true,
        goodColor       = { 0.35, 0.85, 0.40, 1 },
        okColor         = { 0.95, 0.80, 0.30, 1 },
        badColor        = { 0.90, 0.30, 0.30, 1 },
        fpsGood = 60, fpsBad = 30,
        msGood  = 100, msBad = 250,
    },

    -- Section order and membership are fully user-editable. `prioritized` means
    -- the rows get re-sorted to match the current spec's stat priority.
    sections = {
        { id = "primary",       title = "PRIMARY",       enabled = false, showHeader = true,
          stats = { "Primary", "Strength", "Agility", "Intellect", "Stamina" } },
        { id = "enhancements",  title = "ENHANCEMENTS",  enabled = true,  showHeader = true, prioritized = true,
          stats = { "Crit", "Haste", "Mastery", "Versatility" } },
        { id = "defense",       title = "DEFENSE",       enabled = true,  showHeader = true,
          stats = { "Armor", "Dodge", "Parry", "Block" } },
        { id = "supplementary", title = "SUPPLEMENTARY", enabled = true,  showHeader = true,
          stats = { "Leech", "Avoidance", "Speed" } },
    },

    stats = {
        -- "Primary" resolves to whichever of Strength/Agility/Intellect the
        -- character actually scales with, and renames itself to match.
        Primary     = statDefaults({ 0.85, 0.78, 0.55, 1 }, "$value", 10000, 0, "none", false),
        Strength    = statDefaults({ 0.78, 0.61, 0.43, 1 }, "$value", 10000, 0, "none", false),
        Agility     = statDefaults({ 0.67, 0.83, 0.45, 1 }, "$value", 10000, 0, "none", false),
        Intellect   = statDefaults({ 0.41, 0.80, 0.94, 1 }, "$value", 10000, 0, "none", false),
        Stamina     = statDefaults({ 0.85, 0.42, 0.42, 1 }, "$value", 20000, 0, "none", false),

        Crit        = statDefaults({ 0.90, 0.30, 0.32, 1 }, "$value%", 100, 2),
        Haste       = statDefaults({ 0.92, 0.80, 0.30, 1 }, "$value%", 100, 2),
        Mastery     = statDefaults({ 0.40, 0.80, 0.42, 1 }, "$value%", 100, 2),
        Versatility = statDefaults({ 0.36, 0.55, 0.92, 1 }, "$value%", 100, 2),

        Armor       = statDefaults({ 0.55, 0.57, 0.60, 1 }, "$value%", 100, 0),
        Dodge       = statDefaults({ 0.95, 0.60, 0.25, 1 }, "$value%", 100, 2),
        Parry       = statDefaults({ 0.85, 0.45, 0.55, 1 }, "$value%", 100, 2, "value", false),
        Block       = statDefaults({ 0.60, 0.65, 0.80, 1 }, "$value%", 100, 2, "value", false),

        Leech       = statDefaults({ 0.66, 0.40, 0.86, 1 }, "$value%", 100, 2),
        Avoidance   = statDefaults({ 0.30, 0.78, 0.82, 1 }, "$value%", 100, 2),
        -- Skyriding dives run far past any fixed ceiling, so Speed grows its own
        -- scale. "$peak" reports the fastest you've gone this session.
        Speed       = statDefaults({ 0.95, 0.72, 0.38, 1 }, "$value%", 1000, 0),
    },

    -- Chat announcements. Fields the game protects are dropped at send time
    -- rather than filtered here, so this list can stay aspirational.
    announce = {
        channel          = "SELF",
        prefix           = "StatPanel:",
        includeItemLevel = true,
        includeSpec      = true,
        includeStats     = true,
        includePriority  = false,
        includeSpeed     = false,
        includeGear      = true,
    },

    -- [specID] = { "Haste", "Crit", ... }; overrides the built-in priority table.
    customPriority = {},
}

-- Speed is the one stat with no natural ceiling, so it auto-scales by default.
DEFAULTS.stats.Speed.autoMax = true

Config.DEFAULTS = DEFAULTS

-- Keys whose value is replaced wholesale rather than deep-merged. Merging an
-- array index-by-index would resurrect entries the user deliberately removed.
local NO_MERGE = {
    sections = true,
    customPriority = true,
    color = true, bgColor = true, borderColor = true, trackColor = true,
    dividerColor = true, singleColor = true, gradientLow = true, gradientHigh = true,
    sparkColor = true, shadowColor = true, goodColor = true, okColor = true,
    badColor = true, pos = true,
}

--------------------------------------------------------------------------------
-- TABLE HELPERS
--------------------------------------------------------------------------------
local function deepCopy(src)
    if type(src) ~= "table" then return src end
    local out = {}
    for k, v in pairs(src) do out[k] = deepCopy(v) end
    return out
end
Config.DeepCopy = function(_, t) return deepCopy(t) end

-- Fills in anything missing in `dst` from `src` without touching existing values.
local function fillDefaults(dst, src)
    for k, v in pairs(src) do
        if dst[k] == nil then
            dst[k] = deepCopy(v)
        elseif type(v) == "table" and type(dst[k]) == "table" and not NO_MERGE[k] then
            fillDefaults(dst[k], v)
        end
    end
    return dst
end

-- Coerces any stored value whose type no longer matches the schema back to the
-- default. fillDefaults only fills *missing* keys; a key that is present but the
-- wrong type -- a string where a width belongs, a table where a scalar belongs,
-- a color array with a non-number channel -- survives it untouched and then
-- raises inside SetScale / ipairs / SetStatusBarColor at render time. An import
-- string from a stranger or a hand-edited SavedVariables is the usual source,
-- and because the bad profile is saved and active it re-raises on every login.
--
-- This is purely coercive: it never *adds* a key (a missing value stays nil for
-- fillDefaults to handle), it only replaces one of the wrong type. It runs on
-- every Activate, so imports, v1 upgrades and hand-edits are all covered at the
-- one choke point every profile passes through.
local function sanitize(stored, schema)
    if type(schema) ~= "table" then
        -- Leaf: the types must match. A missing value is left for fillDefaults.
        if stored ~= nil and type(stored) ~= type(schema) then return deepCopy(schema) end
        return stored
    end

    if type(stored) ~= "table" then
        -- A table was expected (a subtree, a section list, a color array) and a
        -- scalar -- or nothing -- was stored. There is nothing to salvage.
        if stored ~= nil then return deepCopy(schema) end
        return stored
    end

    -- A fixed-length array of scalars (every color is {r,g,b,a}). If any slot is
    -- missing or the wrong type the whole array is untrustworthy -- and this is
    -- the only place a NO_MERGE color array gets a short or garbled copy
    -- repaired, since fillDefaults deliberately won't reach inside one.
    local n = #schema
    if n > 0 and type(schema[1]) ~= "table" then
        for i = 1, n do
            if type(stored[i]) ~= type(schema[i]) then return deepCopy(schema) end
        end
        return stored
    end

    -- A subtree, or a variable-length list of tables (sections). Walk the schema
    -- keys and coerce each in place; unknown keys the user carries are left be,
    -- and deleted list entries stay deleted (nil coerces to nil).
    for k, v in pairs(schema) do
        stored[k] = sanitize(stored[k], v)
    end
    return stored
end
Config.Sanitize = function(_, profile) return sanitize(profile, DEFAULTS) end

--------------------------------------------------------------------------------
-- PROFILE MANAGEMENT
--------------------------------------------------------------------------------
local function charKey()
    local name = UnitName("player") or "Unknown"
    local realm = GetRealmName() or "Unknown"
    return name .. " - " .. realm
end
Config.CharKey = function() return charKey() end

function Config:Init()
    if type(SPAddonDB) ~= "table" then SPAddonDB = {} end
    local db = SPAddonDB

    -- The schema version the stored DB was written by. A v1 database predates
    -- versioning entirely, so an absent stamp means "1", not "current" -- the
    -- old code stamped it to current up front, which is exactly why the field
    -- was never usefully read. Capture it before anything else touches the DB,
    -- gate migrations on it, and stamp forward once at the end.
    local fromVersion = db.version or 1

    db.profiles = db.profiles or {}
    db.chars    = db.chars or {}
    -- Account-wide settings that deliberately sit outside profiles: switching
    -- looks shouldn't relocate your minimap button or change the editor.
    db.global = db.global or {}
    db.global.minimap = db.global.minimap or { angle = 225, hide = false }
    if db.global.livePreview == nil then db.global.livePreview = true end
    db.global.previewBG = db.global.previewBG or 1

    -- v1 -> v2: a pre-profile database keeps its settings as flat top-level keys.
    -- v1 never wrote a version, so the legacy keys are the real discriminator;
    -- the version gate just keeps this from re-running once a DB has moved on.
    if fromVersion < 2 and (db.showStatPanel ~= nil or db.textColor ~= nil) then
        local legacy = {}
        legacy.panel = { hideInCombat = db.hideInCombat }
        legacy.footer = { showFPS = db.showFPS }
        legacy.enabled = db.showStatPanel
        if db.textColor then
            legacy.font = { elements = { footer = { color = db.textColor } } }
        end
        db.profiles["Default"] = fillDefaults(legacy, DEFAULTS)

        db.showStatPanel, db.textColor, db.hideInCombat = nil, nil, nil
        db.showFPS, db.showHomeLatency, db.showWorldLatency = nil, nil, nil
        db.showEnhancements, db.showDefense, db.showSupplementary = nil, nil, nil
        db.updateInterval, db.fontSize = nil, nil
    end

    -- Future schema steps hook in here, gated the same way:
    --   if fromVersion < 3 then ... end
    -- Everything below runs on every load regardless of version and must stay
    -- idempotent. Once any applicable migration has run, the DB is current.
    db.version = DB_VERSION

    if not db.profiles["Default"] then
        db.profiles["Default"] = deepCopy(DEFAULTS)
    end

    -- Earlier builds stored the auto-scaling ceiling on the saved stat config.
    -- It is session state and never belonged in the profile, so clear it out.
    for _, profile in pairs(db.profiles) do
        if type(profile.stats) == "table" then
            for _, statCfg in pairs(profile.stats) do
                if type(statCfg) == "table" then statCfg.runtimeMax = nil end
            end
        end
    end

    local key = charKey()
    if not db.chars[key] or not db.profiles[db.chars[key]] then
        db.chars[key] = "Default"
    end

    self:Activate(db.chars[key])
end

-- Points SP.db at a profile and makes sure it has every key the current
-- version of the addon expects.
-- Visibility rules that cover opposite states. With both halves of a pair set,
-- ShouldShow() is false in every state and the panel simply never appears --
-- no error, and nothing on screen to say which setting did it. The options UI
-- refuses to create the combination, but an imported string, a hand-edited
-- SavedVariables or a v1 profile can still carry it, so repair it on the way in.
local EXCLUSIVE_VISIBILITY = {
    { "hideInCombat", "onlyInCombat" },
    { "hideInInstance", "hideOutOfInstance" },
}

local function repairVisibility(panel)
    if type(panel) ~= "table" then return end
    for _, pair in ipairs(EXCLUSIVE_VISIBILITY) do
        -- Which half survives is arbitrary; a visible panel beats an invisible
        -- one, and keeping the first leaves the more common rule in place.
        if panel[pair[1]] and panel[pair[2]] then panel[pair[2]] = false end
    end
end

function Config:Activate(name)
    local db = SPAddonDB
    if not db.profiles[name] then name = "Default" end

    db.chars[charKey()] = name
    self.current = name
    -- Coerce wrong-typed values back to defaults before filling gaps, so a
    -- corrupt imported/hand-edited profile can't reach a Set* call and crash the
    -- render. Both operate on and return the stored profile itself, so the
    -- repairs persist.
    local stored = sanitize(db.profiles[name], DEFAULTS)
    db.profiles[name] = stored
    SP.db = fillDefaults(stored, DEFAULTS)
    repairVisibility(SP.db.panel)
    return SP.db
end

function Config:CurrentProfile()
    return self.current or "Default"
end

function Config:ProfileList()
    local out = {}
    for name in pairs(SPAddonDB.profiles) do out[#out + 1] = name end
    table.sort(out, function(a, b) return a:lower() < b:lower() end)
    return out
end

function Config:SetProfile(name)
    if not SPAddonDB.profiles[name] then return false end
    self:Activate(name)
    SP:Refresh()
    return true
end

-- Creates a profile, optionally seeded from an existing one (a copy).
function Config:NewProfile(name, copyFrom)
    name = (name or ""):trim()
    if name == "" then return false, "Profile name cannot be empty." end
    if SPAddonDB.profiles[name] then return false, "A profile named '" .. name .. "' already exists." end

    local source = copyFrom and SPAddonDB.profiles[copyFrom] or DEFAULTS
    SPAddonDB.profiles[name] = deepCopy(source)
    return true
end

function Config:DeleteProfile(name)
    if name == "Default" then return false, "The Default profile cannot be deleted." end
    if not SPAddonDB.profiles[name] then return false, "No such profile." end

    SPAddonDB.profiles[name] = nil

    -- Any character pointed at the deleted profile falls back to Default.
    for char, profile in pairs(SPAddonDB.chars) do
        if profile == name then SPAddonDB.chars[char] = "Default" end
    end

    if self.current == name then
        self:Activate("Default")
        SP:Refresh()
    end
    return true
end

-- Resets the active profile, or just one top-level section of it.
function Config:Reset(section)
    local profile = SPAddonDB.profiles[self:CurrentProfile()]
    if section then
        profile[section] = deepCopy(DEFAULTS[section])
    else
        SPAddonDB.profiles[self:CurrentProfile()] = deepCopy(DEFAULTS)
    end
    self:Activate(self:CurrentProfile())
    SP:Refresh()
end

--------------------------------------------------------------------------------
-- OPTION ACCESS
--------------------------------------------------------------------------------
-- Path-based get/set so the options UI can bind a widget with one string:
--   Config:Get("panel.bgColor")  Config:Set("bars.height", 18)
local function resolve(path, create)
    local node = SP.db
    local last
    for key in path:gmatch("[^%.]+") do
        local index = tonumber(key)
        if index then key = index end
        if last then
            if type(node[last]) ~= "table" then
                if not create then return nil end
                node[last] = {}
            end
            node = node[last]
        end
        last = key
    end
    return node, last
end

function Config:Get(path)
    local node, key = resolve(path)
    if node == nil or key == nil then return nil end
    return node[key]
end

function Config:Set(path, value)
    local node, key = resolve(path, true)
    if node == nil or key == nil then return end
    node[key] = value
    SP:Refresh()
end

-- Color helpers: colors are stored as {r, g, b, a} arrays.
function Config:GetColor(path)
    local c = self:Get(path)
    if type(c) ~= "table" then return 1, 1, 1, 1 end
    return c[1] or 1, c[2] or 1, c[3] or 1, c[4] or 1
end

function Config:SetColor(path, r, g, b, a)
    self:Set(path, { r, g, b, a or 1 })
end

--------------------------------------------------------------------------------
-- IMPORT / EXPORT
--------------------------------------------------------------------------------
-- Profiles serialize to a Lua table constructor, then get base64-encoded so the
-- string survives copy/paste through chat clients and forums intact.
local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

local function base64Encode(data)
    local out = {}
    for i = 1, #data, 3 do
        local a, b, c = data:byte(i, i + 2)
        local n = a * 65536 + (b or 0) * 256 + (c or 0)
        local c1 = math.floor(n / 262144) % 64
        local c2 = math.floor(n / 4096) % 64
        local c3 = math.floor(n / 64) % 64
        local c4 = n % 64
        out[#out + 1] = B64:sub(c1 + 1, c1 + 1) .. B64:sub(c2 + 1, c2 + 1)
            .. (b and B64:sub(c3 + 1, c3 + 1) or "=")
            .. (c and B64:sub(c4 + 1, c4 + 1) or "=")
    end
    return table.concat(out)
end

local B64_INDEX = {}
for i = 1, #B64 do B64_INDEX[B64:sub(i, i)] = i - 1 end

local function base64Decode(data)
    data = data:gsub("[^%w%+/=]", "")
    local out, bits, count = {}, 0, 0
    for i = 1, #data do
        local ch = data:sub(i, i)
        if ch ~= "=" then
            local v = B64_INDEX[ch]
            if not v then return nil end
            bits = bits * 64 + v
            count = count + 1
            if count == 4 then
                out[#out + 1] = string.char(
                    math.floor(bits / 65536) % 256,
                    math.floor(bits / 256) % 256,
                    bits % 256)
                bits, count = 0, 0
            end
        end
    end
    -- Flush the partial group left by '=' padding.
    if count == 3 then
        bits = bits * 64
        out[#out + 1] = string.char(math.floor(bits / 65536) % 256, math.floor(bits / 256) % 256)
    elseif count == 2 then
        bits = bits * 4096
        out[#out + 1] = string.char(math.floor(bits / 65536) % 256)
    end
    return table.concat(out)
end

local function serialize(value)
    local t = type(value)
    if t == "number" then
        return tostring(value)
    elseif t == "boolean" then
        return value and "true" or "false"
    elseif t == "string" then
        return string.format("%q", value)
    elseif t == "table" then
        local parts = {}
        -- Array part first so the round trip preserves order.
        local n = #value
        for i = 1, n do parts[#parts + 1] = serialize(value[i]) end
        for k, v in pairs(value) do
            local skip = type(k) == "number" and k >= 1 and k <= n and math.floor(k) == k
            if not skip then
                local key
                if type(k) == "string" and k:match("^[%a_][%w_]*$") then
                    key = k
                else
                    key = "[" .. serialize(k) .. "]"
                end
                parts[#parts + 1] = key .. "=" .. serialize(v)
            end
        end
        return "{" .. table.concat(parts, ",") .. "}"
    end
    return "nil"
end

function Config:Export(profileName)
    local profile = SPAddonDB.profiles[profileName or self:CurrentProfile()]
    if not profile then return nil end
    return "SP1!" .. base64Encode(serialize(profile))
end

-- Returns the imported profile name on success, or nil plus an error message.
function Config:Import(text, targetName)
    if type(text) ~= "string" then return nil, "Nothing to import." end

    text = text:gsub("%s+", "")

    -- A real profile serializes to a few KB. Cap the input well above that but
    -- far below anything that could hurt: the sandbox stops code from running,
    -- but it can't stop a table constructor like {x=("a"):rep(2^30)} from
    -- allocating gigabytes during pcall, and string methods resolve even in an
    -- empty environment. Reject oversize strings before they reach loadstring.
    if #text > 262144 then return nil, "That import string is too large to be a profile." end

    local payload = text:match("^SP1!(.+)$")
    if not payload then return nil, "That doesn't look like a StatPanel export string." end

    local decoded = base64Decode(payload)
    if not decoded then return nil, "The import string is corrupt." end

    -- The chunk is a bare table constructor; load it in an empty environment so
    -- a malformed or hostile string can't reach into the game's globals.
    local chunk, err = loadstring("return " .. decoded)
    if not chunk then return nil, "Could not read the import string: " .. (err or "?") end
    setfenv(chunk, {})

    local ok, result = pcall(chunk)
    if not ok or type(result) ~= "table" then return nil, "The import string did not contain a profile." end

    targetName = (targetName or ""):trim()
    if targetName == "" then targetName = self:CurrentProfile() end

    SPAddonDB.profiles[targetName] = fillDefaults(result, DEFAULTS)
    self:Activate(targetName)
    SP:Refresh()
    return targetName
end
