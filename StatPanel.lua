-- StatPanel.lua (Panel construction, stat sources, spec-aware priority)
--
-- Nothing in here hardcodes appearance: every size, color, texture, font and
-- format string is read out of SP.db (see Config.lua) on each Rebuild, so the
-- options UI only has to change a value and call SP:Refresh().

local addonName, SP = ...
local NS = SP

local Media = SP.Media

--------------------------------------------------------------------------------
-- API SHIMS
--------------------------------------------------------------------------------
-- Several of these moved into C_ namespaces in recent expansions while the old
-- globals lingered. Bind whichever exists so a future removal doesn't break the
-- whole panel.
local GetSpec     = (C_SpecializationInfo and C_SpecializationInfo.GetSpecialization) or _G.GetSpecialization
local GetSpecInfo = (C_SpecializationInfo and C_SpecializationInfo.GetSpecializationInfo) or _G.GetSpecializationInfo

--------------------------------------------------------------------------------
-- SECRET VALUES (patch 12.0)
--------------------------------------------------------------------------------
-- Some character data now arrives as a "secret value". Addon code may store,
-- pass and DISPLAY these, but may not do arithmetic or comparisons with them,
-- use them as a gsub replacement, or take their length.
--
-- The panel handles this by routing secrets straight into the APIs that accept
-- them (FontString:SetFormattedText, StatusBar:SetValue/SetMinMaxValues) and
-- skipping any feature that would need to inspect the number - bar smoothing,
-- auto-scaling and value gradients degrade rather than error.
local isSecret = _G.issecretvalue or function() return false end
SP.IsSecret = isSecret

-- Returns a value only when it is a plain, usable number: not nil, not secret,
-- and provably safe for arithmetic. Anything else comes back nil so callers can
-- omit the field instead of erroring. The pcall makes this correct even if
-- issecretvalue is ever renamed or removed.
local function plainNumber(value)
    if value == nil or isSecret(value) then return nil end
    local ok, result = pcall(function() return value + 0 end)
    if ok and type(result) == "number" then return result end
    return nil
end
SP.PlainNumber = plainNumber

local function num(fn, ...)
    if type(fn) ~= "function" then return 0 end
    local value = fn(...)
    -- tonumber() on a secret would be a read; pass it through untouched.
    if isSecret(value) then return value end
    return tonumber(value) or 0
end

local CR_ID = {
    Crit        = _G.CR_CRIT_MELEE,
    Haste       = _G.CR_HASTE_MELEE,
    Mastery     = _G.CR_MASTERY,
    Versatility = _G.CR_VERSATILITY_DAMAGE_DONE,
    Dodge       = _G.CR_DODGE,
    Parry       = _G.CR_PARRY,
    Block       = _G.CR_BLOCK,
    Leech       = _G.CR_LIFESTEAL,
    Avoidance   = _G.CR_AVOIDANCE,
    Speed       = _G.CR_SPEED,
}

local function ratingOf(statName)
    local id = CR_ID[statName]
    if id and GetCombatRating then return num(GetCombatRating, id) end
    return 0
end

--------------------------------------------------------------------------------
-- MOVEMENT SPEED
--------------------------------------------------------------------------------
-- GetUnitSpeed returns (currentSpeed, runSpeed, flightSpeed, swimSpeed) in
-- yards/second. Only the FIRST value is your actual velocity; the others are the
-- mount's rated maxima, which is why reading them pins the display at roughly
-- the mount's cap no matter how fast you're really going.
--
-- Skyriding compounds this: a dive accelerates well past any rated speed, and
-- the authoritative figure comes from C_PlayerInfo.GetGlidingInfo(). We take
-- whichever source reports faster, so ground, flight, swim and skyriding all
-- work without special-casing the mount type.
local sessionPeakSpeed = 0

local function GetSpeed()
    local base = _G.BASE_MOVEMENT_SPEED or 7
    local current = num(GetUnitSpeed, "player")

    -- A secret speed can't be compared or divided; hand it straight through so
    -- it still displays, just without the percentage conversion or peak record.
    if isSecret(current) then return current, current end

    if C_PlayerInfo and C_PlayerInfo.GetGlidingInfo then
        local isGliding, _, forwardSpeed = C_PlayerInfo.GetGlidingInfo()
        if isGliding and forwardSpeed and not isSecret(forwardSpeed)
            and forwardSpeed > current then
            current = forwardSpeed
        end
    end

    local percent = (current / base) * 100
    if percent > sessionPeakSpeed then sessionPeakSpeed = percent end
    return percent, current
end

SP.ResetPeakSpeed = function() sessionPeakSpeed = 0 end

-- The peak is a plain number we derived ourselves, never a secret, so unlike
-- most stats it is safe to hand to chat. Announce.lua reads it through here.
SP.GetPeakSpeed = function() return sessionPeakSpeed end

--------------------------------------------------------------------------------
-- ARMOR
--------------------------------------------------------------------------------
-- Armor mitigation constant K used in: reduction = armor / (armor + K).
-- K scales with the *attacker's* level, so it changes whenever the level cap
-- moves. If a future patch raises the cap and these numbers look off, recompute:
--   K = armor * (1 / reductionFraction - 1)
-- using a known armor value and the reduction on the character sheet.
local ARMOR_K_EVENLY_MATCHED = 114808.1 -- same-level / non-boss target
local ARMOR_K_BOSS           = 106634.5 -- +3 level "boss" target

local function GetArmorReduction()
    local armor = select(2, UnitArmor("player")) or 0
    local level = UnitLevel("player") or 80

    -- Damage reduction is a calculation, which a secret armor value forbids.
    -- Fall back to reporting armor itself rather than erroring.
    if isSecret(armor) then return armor, armor end

    local function reduce(k) return (armor / (armor + k)) * 100 end

    local evenlyMatched
    if level < 60 then
        evenlyMatched = (armor / ((85 * level) + armor + 400)) * 100
    else
        evenlyMatched = reduce(ARMOR_K_EVENLY_MATCHED)
    end

    if UnitExists("target") then
        local targetLevel = UnitLevel("target") or -1
        if UnitClassification("target") == "worldboss" or targetLevel == -1 or targetLevel > level + 2 then
            return reduce(ARMOR_K_BOSS), armor
        end
        return evenlyMatched, armor
    end

    return evenlyMatched, armor
end

--------------------------------------------------------------------------------
-- STAT SOURCES
--------------------------------------------------------------------------------
-- Each definition returns: value (the headline number), rating (the raw combat
-- rating behind it, 0 when the stat has none).
--
-- `total` means the figure the character sheet shows (base + rating + buffs);
-- `bonus` means only the contribution from rating. SP.db.valueSource picks
-- which one the panel prefers.
local function primaryStat(index)
    local value = select(2, UnitStat("player", index)) or 0
    return value, value
end

-- Whichever of Strength/Agility/Intellect the character actually scales with.
--
-- Picking the largest is a comparison, which is forbidden on a secret value.
-- Primary stats are readable today, but every other read in this file is
-- guarded and this one should be too: if a patch ever protects them, return the
-- value unnamed so the row still displays under its own label rather than
-- erroring and taking the whole panel down.
local function resolvePrimary()
    local best, bestIndex = -1, 1
    for _, index in ipairs({ 1, 2, 4 }) do
        local value = select(2, UnitStat("player", index)) or 0
        if isSecret(value) then return value, nil end
        if value > best then best, bestIndex = value, index end
    end
    return best, bestIndex
end

local PRIMARY_NAME = { [1] = "Strength", [2] = "Agility", [4] = "Intellect" }

local STAT_DEFS = {
    Primary = {
        name = "Primary",
        get = function()
            local value, index = resolvePrimary()
            -- No index means the attribute couldn't be identified; the row
            -- falls back to its own label rather than naming the wrong stat.
            return value, value, index and PRIMARY_NAME[index]
        end,
    },
    Strength  = { name = "Strength",  get = function() return primaryStat(1) end },
    Agility   = { name = "Agility",   get = function() return primaryStat(2) end },
    Stamina   = { name = "Stamina",   get = function() return primaryStat(3) end },
    Intellect = { name = "Intellect", get = function() return primaryStat(4) end },

    Crit = {
        name = "Crit",
        get = function(source)
            local value = (source == "bonus")
                and num(GetCombatRatingBonus, CR_ID.Crit)
                or  num(GetCritChance)
            return value, ratingOf("Crit")
        end,
    },
    Haste = {
        name = "Haste",
        get = function(source)
            local value = (source == "bonus")
                and num(GetCombatRatingBonus, CR_ID.Haste)
                or  num(GetHaste)
            return value, ratingOf("Haste")
        end,
    },
    Mastery = {
        name = "Mastery",
        get = function(source)
            local value = (source == "bonus")
                and num(GetCombatRatingBonus, CR_ID.Mastery)
                or  num(GetMasteryEffect)
            return value, ratingOf("Mastery")
        end,
    },
    Versatility = {
        name = "Versatility",
        get = function()
            return num(GetCombatRatingBonus, CR_ID.Versatility), ratingOf("Versatility")
        end,
    },

    Armor = { name = "Armor DR", get = function() return GetArmorReduction() end },
    Dodge = { name = "Dodge",     get = function() return num(GetDodgeChance), ratingOf("Dodge") end },
    Parry = { name = "Parry",     get = function() return num(GetParryChance), ratingOf("Parry") end },
    Block = { name = "Block",     get = function() return num(GetBlockChance), ratingOf("Block") end },

    Leech     = { name = "Leech",     get = function() return num(GetLifesteal), ratingOf("Leech") end },
    Avoidance = { name = "Avoidance", get = function() return num(GetAvoidance), ratingOf("Avoidance") end },
    Speed = {
        name = "Speed",
        get = function()
            local percent, yards = GetSpeed()
            return percent, ratingOf("Speed"), nil, yards
        end,
    },
}

SP.STAT_DEFS = STAT_DEFS

-- Stable, display-friendly ordering for the options UI.
SP.STAT_ORDER = {
    "Primary", "Strength", "Agility", "Intellect", "Stamina",
    "Crit", "Haste", "Mastery", "Versatility",
    "Armor", "Dodge", "Parry", "Block",
    "Leech", "Avoidance", "Speed",
}

--------------------------------------------------------------------------------
-- STAT PRIORITY
--------------------------------------------------------------------------------
-- Ordered secondary-stat priority per specialization, keyed by spec ID. These
-- are APPROXIMATE, general-purpose baselines - real priorities shift with gear,
-- content and balance patches, and the authoritative answer for YOUR character
-- comes from a sim. Users can override any spec in the options.
NS.StatPriority = {
    -- Warrior
    [71]  = {"Haste", "Crit", "Mastery", "Versatility"},        -- Arms
    [72]  = {"Haste", "Mastery", "Crit", "Versatility"},        -- Fury
    [73]  = {"Haste", "Versatility", "Mastery", "Crit"},        -- Protection
    -- Paladin
    [65]  = {"Haste", "Crit", "Mastery", "Versatility"},        -- Holy
    [66]  = {"Haste", "Mastery", "Versatility", "Crit"},        -- Protection
    [70]  = {"Haste", "Mastery", "Crit", "Versatility"},        -- Retribution
    -- Hunter
    [253] = {"Haste", "Crit", "Mastery", "Versatility"},        -- Beast Mastery
    [254] = {"Crit", "Haste", "Mastery", "Versatility"},        -- Marksmanship
    [255] = {"Haste", "Crit", "Versatility", "Mastery"},        -- Survival
    -- Rogue
    [259] = {"Crit", "Mastery", "Haste", "Versatility"},        -- Assassination
    [260] = {"Haste", "Crit", "Versatility", "Mastery"},        -- Outlaw
    [261] = {"Crit", "Versatility", "Haste", "Mastery"},        -- Subtlety
    -- Priest
    [256] = {"Haste", "Crit", "Mastery", "Versatility"},        -- Discipline
    [257] = {"Haste", "Crit", "Mastery", "Versatility"},        -- Holy
    [258] = {"Haste", "Mastery", "Crit", "Versatility"},        -- Shadow
    -- Death Knight
    [250] = {"Haste", "Versatility", "Crit", "Mastery"},        -- Blood
    [251] = {"Crit", "Haste", "Mastery", "Versatility"},        -- Frost
    [252] = {"Haste", "Mastery", "Crit", "Versatility"},        -- Unholy
    -- Shaman
    [262] = {"Crit", "Haste", "Mastery", "Versatility"},        -- Elemental
    [263] = {"Haste", "Crit", "Mastery", "Versatility"},        -- Enhancement
    [264] = {"Crit", "Haste", "Versatility", "Mastery"},        -- Restoration
    -- Mage
    [62]  = {"Haste", "Crit", "Mastery", "Versatility"},        -- Arcane
    [63]  = {"Crit", "Haste", "Versatility", "Mastery"},        -- Fire
    [64]  = {"Haste", "Crit", "Versatility", "Mastery"},        -- Frost
    -- Warlock
    [265] = {"Haste", "Mastery", "Crit", "Versatility"},        -- Affliction
    [266] = {"Haste", "Crit", "Mastery", "Versatility"},        -- Demonology
    [267] = {"Haste", "Crit", "Mastery", "Versatility"},        -- Destruction
    -- Monk
    [268] = {"Versatility", "Haste", "Crit", "Mastery"},        -- Brewmaster
    [270] = {"Crit", "Haste", "Versatility", "Mastery"},        -- Mistweaver
    [269] = {"Crit", "Haste", "Mastery", "Versatility"},        -- Windwalker
    -- Druid
    [102] = {"Haste", "Mastery", "Crit", "Versatility"},        -- Balance
    [103] = {"Crit", "Mastery", "Haste", "Versatility"},        -- Feral
    [104] = {"Versatility", "Mastery", "Haste", "Crit"},        -- Guardian
    [105] = {"Haste", "Crit", "Mastery", "Versatility"},        -- Restoration
    -- Demon Hunter
    [577] = {"Crit", "Haste", "Versatility", "Mastery"},        -- Havoc
    [581] = {"Versatility", "Haste", "Crit", "Mastery"},        -- Vengeance
    -- Evoker
    [1467] = {"Mastery", "Crit", "Haste", "Versatility"},       -- Devastation
    [1468] = {"Crit", "Haste", "Mastery", "Versatility"},       -- Preservation
    [1473] = {"Mastery", "Crit", "Haste", "Versatility"},       -- Augmentation
}

local DEFAULT_PRIORITY = { "Crit", "Haste", "Mastery", "Versatility" }

-- Short labels for the compact priority chain line.
local SHORT_NAME = { Crit = "Crit", Haste = "Haste", Mastery = "Mast", Versatility = "Vers" }

-- Returns the priority list for the player's current spec, its name, and its ID.
-- A user override in SP.db.customPriority always wins.
function SP:GetCurrentPriority()
    if not GetSpec then return DEFAULT_PRIORITY end

    local index = GetSpec()
    if not index then return DEFAULT_PRIORITY end

    local specID, specName = GetSpecInfo(index)
    if not specID then return DEFAULT_PRIORITY, specName end

    local custom = SP.db and SP.db.customPriority and SP.db.customPriority[specID]
    return custom or NS.StatPriority[specID] or DEFAULT_PRIORITY, specName, specID
end

-- Maps the many spellings of a secondary stat -- Pawn's rating keys, sim output,
-- and how a person would just type it -- onto our four canonical keys. The key
-- is lowercased with every non-letter stripped, so "Critical Strike",
-- "CritRating" and "crit" all land together.
local SECONDARY_ALIAS = {
    crit = "Crit", critical = "Crit", criticalstrike = "Crit", critrating = "Crit", critstrike = "Crit",
    haste = "Haste", hasterating = "Haste",
    mastery = "Mastery", masteryrating = "Mastery",
    vers = "Versatility", versatility = "Versatility", versatilityrating = "Versatility",
    versa = "Versatility",
}
local SECONDARY_CANON = { "Crit", "Haste", "Mastery", "Versatility" }

local function aliasOf(word)
    return SECONDARY_ALIAS[(word:lower():gsub("[^%a]", ""))]
end

-- Turns a pasted stat-weight string into a full four-stat priority order, or
-- nil plus a reason. Accepts two shapes:
--   * a weight string -- Pawn ("... CritRating=1.2, MasteryRating=1.5 ...") or
--     any "stat = number" list from a sim or stat site -- ordered by descending
--     weight;
--   * a plain order -- "Mastery > Haste > Crit > Vers", commas or spaces too.
-- Any secondary the string omits is appended in canonical order, so the result
-- is always a valid permutation the priority line and dropdowns can consume.
function SP:ParsePriorityString(text)
    if type(text) ~= "string" or strtrim(text) == "" then
        return nil, "Paste a Pawn string or a stat order first."
    end

    -- Weight form: only trust it when the text actually assigns numbers, so a
    -- half-typed Pawn string falls through to an error rather than being read as
    -- a bare word list in file order.
    if text:find("=") then
        local weights, found = {}, 0
        for key, value in text:gmatch("(%a+)%s*=%s*(%-?%d*%.?%d+)") do
            local stat, n = aliasOf(key), tonumber(value)
            if stat and n and not weights[stat] then
                weights[stat] = n
                found = found + 1
            end
        end
        if found < 2 then
            return nil, "Couldn't read at least two secondary-stat weights from that string."
        end

        local order = {}
        for _, stat in ipairs(SECONDARY_CANON) do
            if weights[stat] then order[#order + 1] = stat end
        end
        table.sort(order, function(a, b) return weights[a] > weights[b] end)
        for _, stat in ipairs(SECONDARY_CANON) do
            if not weights[stat] then order[#order + 1] = stat end
        end
        return order
    end

    -- Plain-order form: take the secondaries in the order they appear.
    local order, seen = {}, {}
    for word in text:gmatch("%a+") do
        local stat = aliasOf(word)
        if stat and not seen[stat] then
            seen[stat] = true
            order[#order + 1] = stat
        end
    end
    if #order < 2 then
        return nil, "Couldn't find a stat order in that text. Try 'Mastery > Haste > Crit > Vers'."
    end
    for _, stat in ipairs(SECONDARY_CANON) do
        if not seen[stat] then order[#order + 1] = stat end
    end
    return order
end

--------------------------------------------------------------------------------
-- FORMATTING
--------------------------------------------------------------------------------
local function toHex(color)
    if type(color) ~= "table" then return "|cffffffff" end
    return string.format("|cff%02x%02x%02x",
        math.floor((color[1] or 1) * 255 + 0.5),
        math.floor((color[2] or 1) * 255 + 0.5),
        math.floor((color[3] or 1) * 255 + 0.5))
end
SP.ToHex = toHex

local function commafy(value)
    if isSecret(value) then return value end
    if BreakUpLargeNumbers then return BreakUpLargeNumbers(math.floor(value + 0.5)) end
    return tostring(math.floor(value + 0.5))
end

-- Holds a fontstring inside the panel. Without a width a long line just keeps
-- drawing past the panel's edge and out over the game world, so every text
-- element is bounded and truncated rather than allowed to bleed.
local function clampText(fontString, width, justify)
    if width and width > 0 then fontString:SetWidth(width) end
    fontString:SetWordWrap(false)
    if justify then fontString:SetJustifyH(justify) end
end

-- Measures text as if unbounded (GetStringWidth reports the clamped width once
-- SetWidth is in play, which would stop auto-width from ever growing to fit).
--
-- Returns nil when the width cannot be safely used in arithmetic. Once a
-- fontstring is given secret text the WIDGET is marked as holding secrets, so
-- its reported width is itself secret - on every later frame too, even when the
-- incoming value is ordinary again. Checking the incoming value is therefore
-- not enough; the measurement is verified here at the point of use.
local function stringWidth(fontString)
    if fontString.HasSecretValues and fontString:HasSecretValues() then return nil end

    local getter = fontString.GetUnboundedStringWidth or fontString.GetStringWidth
    local ok, width = pcall(getter, fontString)
    if not ok or width == nil or isSecret(width) then return nil end

    -- Final proof: a secret survives every other check but dies on comparison.
    local usable = pcall(function() return width > 0 end)
    return usable and width or nil
end

-- Escapes literal text so it survives being used as a printf format string.
local function escapePercent(text)
    return (tostring(text or ""):gsub("%%", "%%%%"))
end

-- Turns a $token template into a printf format string plus an ordered list of
-- which live values feed it, e.g.
--   "$rating - $value%"  ->  "%d - %.2f%%", {"rating", "value"}
--
-- This split is what makes the panel secret-safe. Secret values may not be used
-- as a gsub replacement (that raises "invalid replacement value (a secret)"),
-- so the gsub here only ever touches the plain template. The secrets themselves
-- go straight to SetFormattedText, which is one of the few APIs allowed to
-- receive them.
local function buildFormat(template, cfg, label, extra)
    local decimals = math.max(0, math.min(4, cfg.decimals or 0))
    local numberFmt = "%." .. decimals .. "f"
    local order = {}

    -- Escape any literal % in the template before inserting our own specifiers.
    local fmt = escapePercent(template)

    fmt = fmt:gsub("%$(%a+)", function(token)
        if token == "value" or token == "valuec" then
            order[#order + 1] = "value"
            return numberFmt
        elseif token == "rating" or token == "ratingc" then
            order[#order + 1] = "rating"
            return "%d"
        elseif token == "max" then
            return escapePercent(string.format("%d", cfg.max or 100))
        elseif token == "label" then
            return escapePercent(label)
        elseif token == "peak" then
            return escapePercent(string.format(numberFmt, sessionPeakSpeed))
        elseif token == "yards" then
            -- `extra` is the raw yards/sec, which for the Speed stat is the
            -- secret velocity itself when the game protects it (GetSpeed returns
            -- it unchanged). Unlike $value/$rating this token is baked in here by
            -- string.format rather than deferred to SetFormattedText, so it must
            -- be reduced to a plain number first or it raises every frame.
            return escapePercent(string.format("%.1f", plainNumber(extra) or 0))
        end
    end)

    return fmt, order
end

-- Collects the arguments a built format expects, in order.
local function formatArgs(order, value, rating)
    local args = {}
    for index, which in ipairs(order) do
        args[index] = (which == "value") and value or rating
    end
    return args, #order
end

-- string.format with a user-authored template throws if the template carries a
-- stray or extra specifier ("%d %d", "%s"). The rank and footer templates come
-- straight from free-text option boxes and are formatted every frame, so one
-- typo would error continuously. Fall back to the default template, then to the
-- bare value, so a bad template degrades to plain text instead of a flood.
local function safeFormat(template, fallback, value)
    local ok, out = pcall(string.format, template, value)
    if ok then return out end
    ok, out = pcall(string.format, fallback, value)
    if ok then return out end
    return tostring(value)
end

--------------------------------------------------------------------------------
-- PANEL
--------------------------------------------------------------------------------
local Panel = {}
SP.Panel = Panel

Panel.rows = {}       -- [statName] = row frame
Panel.headers = {}    -- [sectionID] = fontstring
Panel.visibleRows = {}-- ordered list of rows currently laid out

-- Session-only ceilings for auto-scaling stats, kept out of the saved profile.
local runtimeMax = {}
SP.ResetRuntimeMax = function() wipe(runtimeMax) end

local frame           -- the StatPanel frame itself

-- Creates the frames for one stat row. Both render styles share the row so
-- switching style never has to rebuild frames.
local function CreateRow(statName)
    local row = CreateFrame("Frame", nil, frame)
    row:SetSize(100, 15)

    row.bar = CreateFrame("StatusBar", nil, row)
    row.bar:SetAllPoints(row)
    row.bar:SetMinMaxValues(0, 100)
    row.bar:SetValue(0)

    row.track = row.bar:CreateTexture(nil, "BACKGROUND")
    row.track:SetAllPoints(row.bar)

    row.spark = row.bar:CreateTexture(nil, "OVERLAY")
    row.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
    row.spark:SetBlendMode("ADD")
    row.spark:Hide()

    -- Text sits on its own frame above the bar so draw order is guaranteed
    -- regardless of the bar's texture layer. It carries the optional per-bar
    -- border too, hence BackdropTemplate.
    row.overlay = CreateFrame("Frame", nil, row, "BackdropTemplate")
    row.overlay:SetAllPoints(row)
    row.overlay:SetFrameLevel(row:GetFrameLevel() + 5)

    row.label = row.overlay:CreateFontString(nil, "OVERLAY")
    row.value = row.overlay:CreateFontString(nil, "OVERLAY")
    row.text  = row.overlay:CreateFontString(nil, "OVERLAY")

    row.statName = statName
    row.smoothed = 0

    -- Dragging anywhere on the panel, including over a row, moves the panel.
    row:RegisterForDrag("LeftButton")
    row:SetScript("OnDragStart", function() Panel:StartDrag() end)
    row:SetScript("OnDragStop", function() Panel:StopDrag() end)
    row:SetScript("OnEnter", function(self) Panel:ShowRowTooltip(self) end)
    row:SetScript("OnLeave", function() GameTooltip:Hide() end)

    -- Rows sit on top of the panel, so they need their own right-click hook or
    -- the context menu would only work in the gaps between bars.
    row:SetScript("OnMouseUp", function(_, mouseButton)
        if mouseButton == "RightButton" then SP:ShowContextMenu(frame) end
    end)

    Panel.rows[statName] = row
    return row
end

function Panel:GetRow(statName)
    return self.rows[statName] or (STAT_DEFS[statName] and CreateRow(statName))
end

--------------------------------------------------------------------------------
-- REBUILD (styling + layout)
--------------------------------------------------------------------------------
-- Applies every appearance setting and repositions everything. Cheap enough to
-- call on any option change; the per-frame update loop only pushes values.
function Panel:Rebuild()
    if not frame or not SP.db then return end

    -- Rebuild ends with an immediate Update, and auto-width can ask for another
    -- Rebuild. The measurement converges in one pass, but guard anyway so a
    -- pathological font can never spin us.
    if self.rebuilding then return end
    self.rebuilding = true

    -- The styling pass applies many saved values in one go. A single bad one --
    -- a font that has since been uninstalled, or a wrong-typed key from an
    -- imported profile -- would raise partway through and leave `rebuilding`
    -- stuck true, turning every future Rebuild into a permanent no-op that not
    -- even switching to a good profile could clear (only /reload would). Run the
    -- body under pcall so the flag always resets and the panel stays
    -- recoverable, and say what happened rather than failing silently.
    local ok, err = pcall(self.RebuildInner, self)
    self.rebuilding = false
    if not ok then
        SP:Print("a display setting could not be applied (" .. tostring(err) .. ").")
    end

    self:Update(0, true)
end

function Panel:RebuildInner()
    local db = SP.db
    local p, b, f = db.panel, db.bars, db.font
    local textStyle = (b.style == "text")

    ----------------------------------------------------------------- frame ----
    frame:SetScale(p.scale or 1)

    -- While previewing, strata and level are owned by FitPreview so the panel
    -- stays above the preview window's backdrop. Applying the saved strata here
    -- would drop it back to MEDIUM and bury it behind the preview.
    if not self.previewing then
        frame:SetFrameStrata(p.strata or "MEDIUM")
        frame:SetFrameLevel(p.frameLevel or 10)
    end

    frame:SetClampedToScreen(p.clamp ~= false)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")

    Media:ApplyBackdrop(frame, {
        bgTexture   = p.bgTexture,
        bgColor     = p.bgColor,
        borderStyle = p.borderStyle,
        borderColor = p.borderColor,
        borderSize  = p.borderSize,
        borderInset = p.borderInset,
        tile        = p.bgTile,
        tileSize    = p.bgTileSize,
    })

    local width = p.autoWidth and (self.measuredWidth or p.minWidth or 120) or (p.width or 208)
    frame:SetWidth(math.max(40, width))

    local shadow = {
        enabled = f.shadow,
        color = f.shadowColor,
        x = f.shadowX,
        y = f.shadowY,
    }
    local function styleText(fontString, element)
        local e = f.elements[element] or {}
        Media:ApplyFont(fontString, f.face, e.size or 12, e.flags, shadow)
        local c = e.color or { 1, 1, 1, 1 }
        fontString:SetTextColor(c[1], c[2], c[3], c[4] or 1)
    end
    self.styleText = styleText

    local padX = p.paddingX or 14
    local innerWidth = frame:GetWidth() - padX * 2

    ----------------------------------------------------------------- title ----
    local y = -(p.paddingTop or 12)

    if p.showTitle and p.titleMode ~= "none" then
        styleText(frame.title, "title")
        frame.title:ClearAllPoints()
        local align = p.titleAlign or "CENTER"
        if align == "LEFT" then
            frame.title:SetPoint("TOPLEFT", frame, "TOPLEFT", padX, y)
        elseif align == "RIGHT" then
            frame.title:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -padX, y)
        else
            frame.title:SetPoint("TOP", frame, "TOP", 0, y)
        end
        clampText(frame.title, innerWidth, align)
        frame.title:Show()
        y = y - (f.elements.title.size or 16) - 6
    else
        frame.title:Hide()
    end

    if p.showDivider then
        frame.divider:ClearAllPoints()
        frame.divider:SetHeight(p.dividerThickness or 1)
        frame.divider:SetPoint("TOPLEFT", frame, "TOPLEFT", padX, y - 2)
        frame.divider:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -padX, y - 2)
        local c = p.dividerColor or { 1, 1, 1, 0.08 }
        frame.divider:SetColorTexture(c[1], c[2], c[3], c[4] or 1)
        frame.divider:Show()
        y = y - (p.dividerThickness or 1) - 6
    else
        frame.divider:Hide()
    end

    ------------------------------------------------------------- sections ----
    for _, row in pairs(self.rows) do row:Hide() end
    for _, header in pairs(self.headers) do header:Hide() end
    frame.priorityLine:Hide()
    wipe(self.visibleRows)

    local priority = SP:GetCurrentPriority()
    local rowHeight = textStyle and (b.textHeight or 15) or (b.height or 15)
    local rowStep = rowHeight + (textStyle and 0 or (b.spacing or 6))
    local barInset = textStyle and 0 or (b.inset or 0)

    for _, section in ipairs(db.sections or {}) do
        if section.enabled then
            local drewSomething = false

            -- Header
            if section.showHeader ~= false and (p.headerStep or 20) > 0 then
                local header = self.headers[section.id]
                if not header then
                    header = frame:CreateFontString(nil, "OVERLAY")
                    self.headers[section.id] = header
                end
                styleText(header, "header")
                header:SetText(section.title or "")
                header:ClearAllPoints()
                local align = p.headerAlign or "LEFT"
                if align == "CENTER" then
                    header:SetPoint("TOP", frame, "TOP", 0, y)
                elseif align == "RIGHT" then
                    header:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -padX, y)
                else
                    header:SetPoint("TOPLEFT", frame, "TOPLEFT", padX, y)
                end
                header:SetJustifyH(align)
                header:Show()
                y = y - (p.headerStep or 20)
            end

            -- Row order: prioritized sections follow the spec priority for any
            -- stat they contain, then append whatever the priority didn't cover.
            local order = section.stats or {}
            if section.prioritized then
                local ordered, seen = {}, {}
                for _, statName in ipairs(priority) do
                    for _, member in ipairs(order) do
                        if member == statName and not seen[statName] then
                            ordered[#ordered + 1] = statName
                            seen[statName] = true
                        end
                    end
                end
                for _, member in ipairs(order) do
                    if not seen[member] then ordered[#ordered + 1] = member end
                end
                order = ordered
            end

            local rank = 1
            for _, statName in ipairs(order) do
                local cfg = db.stats[statName]
                if cfg and cfg.enabled and STAT_DEFS[statName] then
                    local row = self:GetRow(statName)
                    row:ClearAllPoints()
                    row:SetPoint("TOPLEFT", frame, "TOPLEFT", padX + barInset, y)
                    row:SetSize(math.max(1, innerWidth - barInset * 2), rowHeight)
                    self:StyleRow(row, cfg, statName, textStyle, section.prioritized and rank or nil)
                    row:Show()

                    self.visibleRows[#self.visibleRows + 1] = row
                    y = y - rowStep
                    rank = rank + 1
                    drewSomething = true
                end
            end

            -- Priority chain, drawn under the prioritized section.
            if section.prioritized and db.priorityLine.enabled and drewSomething then
                styleText(frame.priorityLine, "priority")
                local chain = {}
                for _, statName in ipairs(priority) do
                    local short = SHORT_NAME[statName] or statName
                    if db.priorityLine.colorize then
                        local statCfg = db.stats[statName]
                        short = toHex(statCfg and statCfg.color) .. short .. "|r"
                    end
                    chain[#chain + 1] = short
                end
                local text = table.concat(chain, db.priorityLine.separator or " > ")
                if db.priorityLine.showSpec then
                    local _, specName = SP:GetCurrentPriority()
                    if specName then text = specName .. ": " .. text end
                end
                frame.priorityLine:SetText(text)
                frame.priorityLine:ClearAllPoints()
                frame.priorityLine:SetPoint("TOPLEFT", frame, "TOPLEFT", padX, y + 2)
                clampText(frame.priorityLine, innerWidth, "LEFT")
                frame.priorityLine:Show()
                y = y - (f.elements.priority.size or 10) - 6
            end

            if drewSomething then y = y - (p.sectionGap or 8) end
        end
    end

    --------------------------------------------------------------- footer ----
    if db.footer.enabled then
        styleText(frame.footer, "footer")
        frame.footer:ClearAllPoints()
        frame.footer:SetPoint("TOP", frame, "TOP", 0, y - 2)
        clampText(frame.footer, innerWidth, "CENTER")
        frame.footer:Show()
        y = y - (f.elements.footer.size or 13) - 4
    else
        frame.footer:Hide()
    end

    frame:SetHeight(math.max(20, -y + (p.paddingBottom or 8)))

    self:ApplyPosition()
    self:UpdateAlpha(true)
    self:FitPreview()
end

--------------------------------------------------------------------------------
-- LIVE PREVIEW
--------------------------------------------------------------------------------
-- Rather than maintaining a second copy of the rendering code, the preview
-- re-parents the real panel into the options window. What you see is literally
-- the live panel, updating as you drag sliders, and it goes home on close.

function Panel:EnterPreview(container)
    if self.previewing or not frame or not container then return end

    self.previewing = true
    self.previewContainer = container
    self.preStash = {
        parent = frame:GetParent() or UIParent,
        strata = frame:GetFrameStrata(),
        level  = frame:GetFrameLevel(),
    }

    frame:SetParent(container)
    frame:SetFrameStrata("FULLSCREEN_DIALOG")
    frame:SetFrameLevel(100)
    frame:ClearAllPoints()
    frame:SetPoint("CENTER", container, "CENTER", 0, 0)
    frame:Show()

    self:Rebuild()
end

function Panel:ExitPreview()
    if not self.previewing then return end

    self.previewing = false
    self.previewContainer = nil

    local stash = self.preStash or {}
    frame:SetParent(stash.parent or UIParent)
    frame:SetFrameStrata(stash.strata or "MEDIUM")
    frame:SetFrameLevel(stash.level or 10)
    self.preStash = nil

    self:Rebuild()          -- restores the real scale and position
    self:ApplyVisibility()
end

-- Shrinks the panel just enough to fit the preview box. The saved scale is
-- untouched; this only affects how it's displayed while previewing.
function Panel:FitPreview()
    if not self.previewing or not self.previewContainer then return end

    local containerW, containerH = self.previewContainer:GetSize()
    local width, height = frame:GetWidth(), frame:GetHeight()
    if not containerW or containerW <= 0 or width <= 0 or height <= 0 then return end

    -- Only ever shrink, never magnify: the preview should represent the real
    -- size. A small margin keeps the panel's border off the preview's edge.
    local fit = math.min(
        SP.db.panel.scale or 1,
        (containerW - 8) / width,
        (containerH - 8) / height)

    frame:SetScale(math.max(0.3, fit))

    -- Re-assert all three every rebuild. Strata matters most: it outranks frame
    -- level entirely, so a panel left on MEDIUM renders behind the preview
    -- window no matter how high its level is.
    frame:SetAlpha(1)
    frame:SetFrameStrata(self.previewContainer:GetFrameStrata())
    frame:SetFrameLevel((self.previewContainer:GetFrameLevel() or 1) + 20)
end

-- Applies bar/text styling to a single row.
function Panel:StyleRow(row, cfg, statName, textStyle, rank)
    local db = SP.db
    local b, f = db.bars, db.font

    local color = self:RowColor(cfg, statName)

    if textStyle then
        row.bar:Hide()
        row.label:Hide()
        row.value:Hide()
        row.text:Show()

        Media:ApplyFont(row.text, f.face, (f.elements.label.size or 12), f.elements.label.flags,
            { enabled = f.shadow, color = f.shadowColor, x = f.shadowX, y = f.shadowY })
        row.text:SetTextColor(1, 1, 1, 1) -- per-part colors come from escape codes

        row.text:ClearAllPoints()
        local align = b.align or "LEFT"
        if align == "CENTER" then
            row.text:SetPoint("CENTER", row, "CENTER", 0, 0)
        elseif align == "RIGHT" then
            row.text:SetPoint("RIGHT", row, "RIGHT", b.valueX or 0, 0)
        else
            row.text:SetPoint("LEFT", row, "LEFT", b.labelX or 0, 0)
        end
        clampText(row.text, row:GetWidth(), align)
    else
        row.text:Hide()
        row.bar:Show()

        row.bar:SetStatusBarTexture(Media:Fetch("statusbar", b.texture))
        row.bar:SetStatusBarColor(color[1], color[2], color[3], (color[4] or 1) * (b.alpha or 1))
        row.bar:SetOrientation(b.orientation or "HORIZONTAL")
        row.bar:SetReverseFill(b.reverseFill or false)

        row.track:SetTexture(Media:Fetch("background", b.trackTexture))
        if b.trackUseStatColor then
            row.track:SetVertexColor(color[1], color[2], color[3], b.trackStatAlpha or 0.15)
        else
            local t = b.trackColor or { 0, 0, 0, 0.45 }
            row.track:SetVertexColor(t[1], t[2], t[3], t[4] or 1)
        end

        -- Optional per-bar border, drawn on the overlay frame.
        local border = Media:FetchBorder(b.borderStyle, b.borderSize)
        if border then
            Media:ApplyBackdrop(row.overlay, {
                borderStyle = b.borderStyle,
                borderColor = b.borderColor,
                borderSize  = b.borderSize,
            })
        elseif row.overlay.SetBackdrop then
            row.overlay:SetBackdrop(nil)
        end

        if b.spark then
            local s = b.sparkColor or { 1, 1, 1, 0.55 }
            row.spark:SetVertexColor(s[1], s[2], s[3], s[4] or 1)
            row.spark:SetSize(16, (b.height or 15) * 2.2)
            row.spark:Show()
        else
            row.spark:Hide()
        end

        -- Label
        if b.showLabel then
            self.styleText(row.label, "label")
            if b.labelUseStatColor then
                row.label:SetTextColor(color[1], color[2], color[3], color[4] or 1)
            end
            row.label:ClearAllPoints()
            row.label:SetPoint("LEFT", row, "LEFT", b.labelX or 5, 0)
            -- Name and value share the row, so cap each at roughly its half.
            clampText(row.label, math.max(10, row:GetWidth() * 0.62), "LEFT")
            row.label:Show()
        else
            row.label:Hide()
        end

        -- Value
        if b.showValue then
            self.styleText(row.value, "value")
            if b.valueUseStatColor then
                row.value:SetTextColor(color[1], color[2], color[3], color[4] or 1)
            end
            row.value:ClearAllPoints()
            row.value:SetPoint("RIGHT", row, "RIGHT", b.valueX or -5, 0)
            clampText(row.value, math.max(10, row:GetWidth() * 0.55), "RIGHT")
            row.value:Show()
        else
            row.value:Hide()
        end
    end

    row.rank = rank
    row:EnableMouse(db.panel.tooltips ~= false)
end

-- Resolves the color a row should use, honoring the global color mode.
function Panel:RowColor(cfg, statName)
    local b = SP.db.bars

    if cfg.useClassColor or b.colorMode == "class" then
        local _, class = UnitClass("player")
        local c = class and RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]
        if c then return { c.r, c.g, c.b, 1 } end
    end

    if b.colorMode == "single" then
        return b.singleColor or { 0.35, 0.6, 0.9, 1 }
    end

    if b.colorMode == "gradient" then
        local row = self.rows[statName]
        local pct = 0
        -- lastValue is left nil for secret stats, which keeps this arithmetic
        -- safe and simply parks the gradient at its low end.
        if row and row.lastValue and cfg.max and cfg.max > 0 then
            pct = math.min(1, row.lastValue / cfg.max)
        end
        local lo, hi = b.gradientLow or { 1, 0, 0, 1 }, b.gradientHigh or { 0, 1, 0, 1 }
        return {
            lo[1] + (hi[1] - lo[1]) * pct,
            lo[2] + (hi[2] - lo[2]) * pct,
            lo[3] + (hi[3] - lo[3]) * pct,
            1,
        }
    end

    return cfg.color or { 0.5, 0.5, 0.5, 1 }
end

--------------------------------------------------------------------------------
-- POSITION / VISIBILITY
--------------------------------------------------------------------------------
function Panel:ApplyPosition()
    -- While previewing, the frame is anchored inside the options window; don't
    -- drag it back to its real spot on every settings change.
    if self.previewing then return end

    local pos = SP.db.panel.pos or {}
    frame:ClearAllPoints()
    frame:SetPoint(pos.point or "CENTER", UIParent, pos.relPoint or "CENTER", pos.x or 0, pos.y or 0)
end

function Panel:SavePosition()
    local point, _, relPoint, x, y = frame:GetPoint()
    SP.db.panel.pos = { point = point, relPoint = relPoint, x = x, y = y }
end

function Panel:StartDrag()
    if SP.db.panel.locked or self.previewing then return end
    frame:StartMoving()
    frame.isMoving = true
end

function Panel:StopDrag()
    if not frame.isMoving then return end
    frame:StopMovingOrSizing()
    frame.isMoving = false
    self:SavePosition()
end

-- Single source of truth for whether the panel should currently be visible.
function Panel:ShouldShow()
    local db = SP.db
    if not db.enabled then return false end

    local p = db.panel
    local inCombat = InCombatLockdown()

    if p.hideInCombat and inCombat then return false end
    if p.onlyInCombat and not inCombat then return false end
    if p.hideWhenDead and UnitIsDeadOrGhost("player") then return false end
    if p.hideInVehicle and UnitInVehicle("player") then return false end
    if p.hideInPetBattle and C_PetBattles and C_PetBattles.IsInBattle() then return false end

    if p.hideInInstance or p.hideOutOfInstance then
        local inInstance = IsInInstance()
        if p.hideInInstance and inInstance then return false end
        if p.hideOutOfInstance and not inInstance then return false end
    end

    return true
end

function Panel:ApplyVisibility()
    if not frame or not SP.db then return end

    -- The preview ignores visibility rules on purpose: you need to see what
    -- you're configuring even if the panel is set to hide out of combat.
    if self.previewing then
        frame:Show()
        return
    end

    if self:ShouldShow() then frame:Show() else frame:Hide() end
end

-- Target alpha depends on whether the cursor is over the panel (mouseover mode).
function Panel:UpdateAlpha(instant)
    local p = SP.db.panel
    local target = p.alpha or 1

    -- Likewise, a mouseover-fade setting shouldn't make the preview invisible.
    if self.previewing then
        frame.targetAlpha = 1
        frame:SetAlpha(1)
        return
    end

    if p.mouseoverOnly and not frame.hovered then
        target = p.fadeAlpha or 0
    end

    frame.targetAlpha = target
    if instant or (p.fadeDuration or 0) <= 0 then
        frame:SetAlpha(target)
    end
end

--------------------------------------------------------------------------------
-- TOOLTIP
--------------------------------------------------------------------------------
function Panel:ShowRowTooltip(row)
    frame.hovered = true
    self:UpdateAlpha()

    if not SP.db.panel.tooltips then return end

    local def = STAT_DEFS[row.statName]
    local cfg = SP.db.stats[row.statName]
    if not def or not cfg then return end

    GameTooltip:SetOwner(row, "ANCHOR_RIGHT")
    GameTooltip:AddLine(cfg.label or def.name, 1, 1, 1)

    local value, rating, dynamicName, extra = def.get(SP.db.valueSource)

    -- Tooltip lines are built by us rather than by SetFormattedText, so secret
    -- numbers can't go in them. Say so plainly instead of showing nothing.
    if isSecret(value) or isSecret(rating) then
        GameTooltip:AddLine("The game protects this value; see the panel itself.", 0.6, 0.6, 0.6, true)
    else
        GameTooltip:AddDoubleLine("Value", string.format("%.2f", value), 0.7, 0.7, 0.7, 1, 1, 1)
        if rating and rating > 0 then
            GameTooltip:AddDoubleLine("Rating", commafy(rating), 0.7, 0.7, 0.7, 1, 1, 1)
        end
        if row.statName == "Speed" and not isSecret(extra) then
            GameTooltip:AddDoubleLine("Yards/sec", string.format("%.1f", extra or 0), 0.7, 0.7, 0.7, 1, 1, 1)
            GameTooltip:AddDoubleLine("Session peak", string.format("%.0f%%", sessionPeakSpeed), 0.7, 0.7, 0.7, 1, 1, 1)
        end
    end
    if dynamicName then
        GameTooltip:AddDoubleLine("Attribute", dynamicName, 0.7, 0.7, 0.7, 1, 1, 1)
    end

    if not SP.db.panel.locked then
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("Drag to move  |  /sp for options", 0.5, 0.5, 0.5)
    end
    GameTooltip:Show()
end

--------------------------------------------------------------------------------
-- UPDATE LOOP
--------------------------------------------------------------------------------
local elapsedSinceUpdate = 0

function Panel:Update(elapsed, force)
    if not frame or not SP.db then return end

    local db = SP.db
    local p, b, f = db.panel, db.bars, db.font
    local textStyle = (b.style == "text")

    -- Alpha fade toward the target set by mouseover state.
    if frame.targetAlpha and (p.fadeDuration or 0) > 0 then
        local current = frame:GetAlpha()
        if math.abs(current - frame.targetAlpha) > 0.005 then
            local step = (elapsed or 0) / (p.fadeDuration or 0.25)
            local delta = frame.targetAlpha - current
            frame:SetAlpha(current + delta * math.min(1, step))
        end
    end

    elapsedSinceUpdate = elapsedSinceUpdate + (elapsed or 0)
    if not force and elapsedSinceUpdate < (db.updateInterval or 0.1) then
        -- Bar smoothing still needs to run every frame to look smooth.
        if b.smooth and not textStyle then self:SmoothBars(elapsed) end
        return
    end
    local step = elapsedSinceUpdate
    elapsedSinceUpdate = 0

    if not frame:IsShown() then return end

    ---------------------------------------------------------------- title ----
    if p.showTitle and p.titleMode ~= "none" then
        self:UpdateTitle()
    end

    ----------------------------------------------------------------- rows ----
    local widest = 0
    local anySecret = false   -- set when any row's value is protected

    for _, row in ipairs(self.visibleRows) do
        local statName = row.statName
        local def = STAT_DEFS[statName]
        local cfg = db.stats[statName]

        if def and cfg then
            local value, rating, dynamicName, extra = def.get(db.valueSource)
            value = value or 0
            rating = rating or 0

            -- A secret value can be displayed but not inspected. Everything
            -- below that needs to read the number is skipped when it is.
            local secret = isSecret(value) or isSecret(rating)
            row.secret = secret
            row.lastValue = (not secret) and value or nil
            if secret then anySecret = true end

            -- Auto-scaling stats grow their ceiling instead of pinning at max.
            -- The grown ceiling is deliberately kept out of the saved profile:
            -- it is session state, and storing a secret there would persist it.
            local maxValue = cfg.max or 100
            if cfg.autoMax then
                local grown = runtimeMax[statName]
                if not secret and not isSecret(value) then
                    grown = math.max(grown or maxValue, value)
                    runtimeMax[statName] = grown
                end
                maxValue = grown or maxValue
            end

            local label = cfg.label or dynamicName or def.name
            local valueFmt, order = buildFormat(cfg.format or "$value", cfg, label, extra)
            local args, argCount = formatArgs(order, value, rating)

            if textStyle then
                local color = self:RowColor(cfg, statName)
                local labelColor = b.labelUseStatColor and toHex(color) or toHex(f.elements.label.color)
                local valueColor = b.valueUseStatColor and toHex(color) or toHex(f.elements.value.color)

                -- The whole line is one format string with the color escapes
                -- baked in, so the secret arguments go straight to
                -- SetFormattedText without ever being concatenated by us.
                local lineFmt = ""
                if b.showLabel then
                    local prefix = ""
                    if b.showRank and row.rank then
                        prefix = safeFormat(b.rankFormat or "%d  ", "%d  ", row.rank)
                    end
                    lineFmt = labelColor .. escapePercent(prefix .. label) .. "|r"
                end
                if b.showValue then
                    if b.showLabel then lineFmt = lineFmt .. escapePercent(b.textSep or ": ") end
                    lineFmt = lineFmt .. valueColor .. valueFmt .. "|r"
                end

                row.text:SetFormattedText(lineFmt, unpack(args, 1, argCount))

                local w = stringWidth(row.text)
                if w and w > widest then widest = w end
            else
                if b.showLabel then
                    local prefix = ""
                    if b.showRank and row.rank then
                        prefix = safeFormat(b.rankFormat or "%d  ", "%d  ", row.rank)
                    end
                    row.label:SetText(prefix .. label)
                end
                if b.showValue then
                    row.value:SetFormattedText(valueFmt, unpack(args, 1, argCount))
                end

                -- Bar fill. StatusBar:SetValue is one of the APIs that accepts
                -- a secret, so the bar still tracks even when we can't read it.
                local fillValue = value
                if cfg.fill == "full" then
                    fillValue = maxValue
                elseif cfg.fill == "none" then
                    fillValue = 0
                end

                row.bar:SetMinMaxValues(0, maxValue > 0 and maxValue or 1)
                row.targetValue = fillValue

                -- Smoothing needs arithmetic on the value, so secret rows jump
                -- straight to their target instead of easing.
                if not b.smooth or secret then
                    row.bar:SetValue(fillValue)
                    row.smoothed = (not secret) and fillValue or nil
                end

                if b.colorMode == "gradient" and not secret then
                    local color = self:RowColor(cfg, statName)
                    row.bar:SetStatusBarColor(color[1], color[2], color[3], (color[4] or 1) * (b.alpha or 1))
                end

                if b.spark and not secret then
                    local pct = maxValue > 0 and math.min(1, (row.smoothed or 0) / maxValue) or 0
                    row.spark:ClearAllPoints()
                    row.spark:SetPoint("CENTER", row.bar, "LEFT", pct * row.bar:GetWidth(), 0)
                end

                local labelW, valueW = stringWidth(row.label), stringWidth(row.value)
                if labelW and valueW then
                    local w = labelW + valueW + 20
                    if w > widest then widest = w end
                end
            end
        end
    end

    if b.smooth and not textStyle then self:SmoothBars(step) end

    --------------------------------------------------------------- footer ----
    if db.footer.enabled then
        frame.footer:SetText(self:BuildFooter())
        local w = stringWidth(frame.footer)
        if w and w > widest then widest = w end
    end

    if p.showTitle then
        local w = stringWidth(frame.title)
        if w and w > widest then widest = w end
    end

    -- The priority chain is often the widest line on the panel, so auto-width
    -- has to account for it too.
    if frame.priorityLine:IsShown() then
        local w = stringWidth(frame.priorityLine)
        if w and w > widest then widest = w end
    end

    ------------------------------------------------------------ auto width ----
    -- A FontString holding a secret can't be measured, so auto-width simply
    -- leaves the panel at its current size rather than collapsing it.
    if p.autoWidth and not anySecret and not self.titleSecret and widest > 0 then
        local target = math.max(p.minWidth or 120, math.ceil((widest + (p.paddingX or 14) * 2) / 2) * 2)
        if math.abs((self.measuredWidth or 0) - target) >= 2 then
            self.measuredWidth = target
            -- Re-running the layout resizes rows to match the new width.
            self:Rebuild()
        end
    end
end

-- Eases every bar toward its target so value changes don't snap. Rows carrying
-- a secret value are skipped: easing needs arithmetic the game won't allow, and
-- they were already set to their exact value during the update.
function Panel:SmoothBars(elapsed)
    local speed = SP.db.bars.smoothSpeed or 8
    for _, row in ipairs(self.visibleRows) do
        if not row.secret then
            local target = row.targetValue or 0
            local current = row.smoothed or 0
            if math.abs(target - current) < 0.01 then
                row.smoothed = target
            else
                row.smoothed = current + (target - current) * math.min(1, (elapsed or 0) * speed)
            end
            row.bar:SetValue(row.smoothed)
        end
    end
end

-- Sets the title directly rather than returning a string: item level may be a
-- secret, and the only safe way to render one is to hand it to
-- SetFormattedText as an argument (see buildFormat).
function Panel:UpdateTitle()
    local p = SP.db.panel
    local mode = p.titleMode or "ilvl"
    self.titleSecret = false

    if mode == "custom" then frame.title:SetText(p.titleText or "") return end
    if mode == "name" then frame.title:SetText(UnitName("player") or "") return end
    if mode == "spec" then
        local _, specName = SP:GetCurrentPriority()
        frame.title:SetText(specName or "")
        return
    end

    local overall, equipped = GetAverageItemLevel()
    overall, equipped = overall or 0, equipped or 0
    self.titleSecret = isSecret(overall) or isSecret(equipped)

    local decimals = math.max(0, math.min(2, p.titleDecimals or 1))
    local numberFmt = "%." .. decimals .. "f"
    local order = {}

    local fmt = escapePercent(p.titleFormat or "iLvl $equipped")
    fmt = fmt:gsub("%$(%a+)", function(token)
        if token == "equipped" then
            order[#order + 1] = "equipped"
            return numberFmt
        elseif token == "overall" then
            order[#order + 1] = "overall"
            return numberFmt
        elseif token == "name" then
            return escapePercent(UnitName("player"))
        elseif token == "level" then
            return escapePercent(tostring(UnitLevel("player") or ""))
        elseif token == "class" then
            return escapePercent(UnitClass("player"))
        elseif token == "spec" then
            local _, specName = SP:GetCurrentPriority()
            return escapePercent(specName)
        end
    end)

    local args = {}
    for index, which in ipairs(order) do
        args[index] = (which == "equipped") and equipped or overall
    end

    frame.title:SetFormattedText(fmt, unpack(args, 1, #order))
end

-- UpdateAddOnMemoryUsage() re-tallies memory for *every* loaded addon, not just
-- this one. BuildFooter runs from the update loop, so at the default 0.1s
-- interval that was firing ten times a second - easily the most expensive thing
-- the panel did, and on a busy addon list it is measurable. The number barely
-- moves between frames, so sample it a few seconds apart and reuse it.
local MEMORY_SAMPLE_INTERVAL = 5
local memoryKB, lastMemorySample = 0, 0

local function GetMemoryKB()
    local now = GetTime()
    if now - lastMemorySample >= MEMORY_SAMPLE_INTERVAL then
        lastMemorySample = now
        UpdateAddOnMemoryUsage()
        memoryKB = GetAddOnMemoryUsage(addonName) or 0
    end
    return memoryKB
end

-- Picks good/ok/bad coloring for a performance number.
local function qualityColor(value, good, bad, higherIsBetter)
    local footer = SP.db.footer
    if not footer.colorize then return nil end
    -- Thresholds are comparisons, which a secret forbids.
    if isSecret(value) then return nil end

    if higherIsBetter then
        if value >= good then return footer.goodColor end
        if value <= bad then return footer.badColor end
    else
        if value <= good then return footer.goodColor end
        if value >= bad then return footer.badColor end
    end
    return footer.okColor
end

function Panel:BuildFooter()
    local footer = SP.db.footer
    local parts = {}

    -- We concatenate the footer ourselves, so a secret string can't go in it.
    local function add(text, color)
        if isSecret(text) then return end
        if color then
            parts[#parts + 1] = toHex(color) .. text .. "|r"
        else
            parts[#parts + 1] = text
        end
    end

    if footer.showFPS then
        local fps = GetFramerate() or 0
        add(safeFormat(footer.fpsFormat or "%.0f fps", "%.0f fps", fps),
            qualityColor(fps, footer.fpsGood or 60, footer.fpsBad or 30, true))
    end

    if footer.showHomeLatency or footer.showWorldLatency then
        local _, _, home, world = GetNetStats()
        if footer.showHomeLatency then
            add(safeFormat(footer.homeFormat or "%d ms", "%d ms", home or 0),
                qualityColor(home or 0, footer.msGood or 100, footer.msBad or 250, false))
        end
        if footer.showWorldLatency then
            add(safeFormat(footer.worldFormat or "%d ms", "%d ms", world or 0),
                qualityColor(world or 0, footer.msGood or 100, footer.msBad or 250, false))
        end
    end

    if footer.showMemory then
        add(safeFormat(footer.memoryFormat or "%.1f mb", "%.1f mb", GetMemoryKB() / 1024))
    end

    return table.concat(parts, footer.separator or "  |  ")
end

--------------------------------------------------------------------------------
-- CONSTRUCTION
--------------------------------------------------------------------------------
function SP:CreatePanel()
    if frame then return frame end

    frame = CreateFrame("Frame", "StatPanelFrame", UIParent, "BackdropTemplate")
    SP.frame = frame
    _G.SPAddon_StatPanel = frame

    frame:SetSize(208, 100)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function() Panel:StartDrag() end)
    frame:SetScript("OnDragStop", function() Panel:StopDrag() end)

    frame:SetScript("OnEnter", function()
        frame.hovered = true
        Panel:UpdateAlpha()
    end)
    frame:SetScript("OnLeave", function()
        frame.hovered = false
        Panel:UpdateAlpha()
        GameTooltip:Hide()
    end)

    frame:SetScript("OnMouseUp", function(self, mouseButton)
        if mouseButton == "RightButton" then SP:ShowContextMenu(self) end
    end)

    frame.title = frame:CreateFontString(nil, "OVERLAY")
    frame.divider = frame:CreateTexture(nil, "ARTWORK")
    frame.priorityLine = frame:CreateFontString(nil, "OVERLAY")
    frame.footer = frame:CreateFontString(nil, "OVERLAY")

    frame:SetScript("OnUpdate", function(_, elapsed) Panel:Update(elapsed) end)

    Panel:Rebuild()
    Panel:ApplyVisibility()

    return frame
end

-- Re-reads every setting and redraws. Called by the options UI on any change.
function SP:Refresh()
    if not frame then return end
    Panel:Rebuild()
    Panel:ApplyVisibility()
end

function SP:TogglePanel()
    SP.db.enabled = not SP.db.enabled
    Panel:ApplyVisibility()
    return SP.db.enabled
end

--------------------------------------------------------------------------------
-- EVENTS
--------------------------------------------------------------------------------
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_DEAD")
eventFrame:RegisterEvent("PLAYER_ALIVE")
eventFrame:RegisterEvent("PLAYER_UNGHOST")
eventFrame:RegisterEvent("PET_BATTLE_OPENING_START")
eventFrame:RegisterEvent("PET_BATTLE_CLOSE")
-- These three carry a unit and fire for every group member, not just you. The
-- handler ignores the unit, so an ally respeccing or taking a vehicle would
-- otherwise force a full Rebuild / visibility recompute on your panel. Filter
-- to "player" at registration so those never reach us.
eventFrame:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player")
eventFrame:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player")
eventFrame:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player")

eventFrame:SetScript("OnEvent", function(_, event)
    if not SP.db or not frame then return end

    if event == "PLAYER_SPECIALIZATION_CHANGED" or event == "PLAYER_ENTERING_WORLD" then
        -- Spec changed: prioritized sections need re-ordering.
        Panel:Rebuild()
    end
    Panel:ApplyVisibility()
end)

--------------------------------------------------------------------------------
-- BACKWARDS-COMPATIBLE GLOBALS
--------------------------------------------------------------------------------
-- Kept so anything referencing the old entry points (macros, other addons)
-- keeps working after the rewrite.
function CreateStatPanel() return SP:CreatePanel() end
function SPAddon_ApplyVisibility() Panel:ApplyVisibility() end
function ToggleStatPanel() SP:TogglePanel() end

NS.RelayoutPanel = function() Panel:Rebuild() end
