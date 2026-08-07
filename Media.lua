-- Media.lua (Texture / font / border registry)
--
-- Every visual asset the panel can use is looked up through this module, which
-- gives us one place to add new options and one place to fall back safely when
-- a saved name no longer exists (e.g. the user uninstalled the addon that
-- provided a shared-media texture).
--
-- LibSharedMedia-3.0 is an OPTIONAL dependency. If any addon in the user's
-- setup provides it (ElvUI, WeakAuras, Details!, Plater, ...) every texture and
-- font registered there shows up in our dropdowns automatically. Without it we
-- still ship a curated list of Blizzard-shipped assets.

local addonName, SP = ...
local L = SP.L

local Media = {}
SP.Media = Media

local LSM = _G.LibStub and _G.LibStub("LibSharedMedia-3.0", true)
Media.LSM = LSM

--------------------------------------------------------------------------------
-- THE CLIENT'S OWN FONT
--------------------------------------------------------------------------------
-- FRIZQT__.TTF covers Latin script and nothing else. Naming it directly -- which
-- this addon used to do in eleven places -- renders Cyrillic, Korean and both
-- Chinese scripts as empty boxes, which is why those four translations could not
-- ship. Blizzard already solved this: STANDARD_TEXT_FONT is set per client
-- locale and points at a file that can draw that locale's text.
--
-- Every piece of chrome the addon draws for itself (the options window, the
-- widgets, the preview) asks for this rather than naming a file. The panel
-- proper is different -- there the font is a user-facing setting, so it goes
-- through Media:Fetch("font", ...) like any other choice.
local LATIN_FONT = [[Fonts\FRIZQT__.TTF]]

local resolvedUIFont

-- Cached because it cannot change without a client restart, and this is called
-- once per font string in a 1600-line options window.
function Media:UIFont()
    if resolvedUIFont then return resolvedUIFont end

    local candidate = _G.STANDARD_TEXT_FONT

    if type(candidate) ~= "string" or candidate == "" then
        -- Whatever GameFontNormal is actually using is the same answer by a
        -- different route, and survives STANDARD_TEXT_FONT being retired.
        local font = _G.GameFontNormal
        if font and font.GetFont then
            local ok, path = pcall(font.GetFont, font)
            if ok and type(path) == "string" and path ~= "" then
                candidate = path
            end
        end
    end

    resolvedUIFont = (type(candidate) == "string" and candidate ~= "")
        and candidate or LATIN_FONT
    return resolvedUIFont
end

-- Shorthand, since this is called from three other files.
SP.UIFont = function() return Media:UIFont() end

-- The four clients whose text FRIZQT__.TTF and friends cannot draw. Korean and
-- both Chinese clients ship those filenames but with Latin glyphs only, so the
-- font loads, reports success, and renders boxes -- there is no error to catch.
-- Russian is included for safety: its Friz Quadrata does carry Cyrillic, so the
-- substitution is visually identical there and costs nothing.
local NON_LATIN_LOCALE = {
    koKR = true, zhCN = true, zhTW = true, ruRU = true,
}

-- Built-in faces that are Latin-only. Shared-media fonts are NOT listed: those
-- come from another addon that knows its own audience, and second-guessing a
-- font the user deliberately installed would be worse than the problem.
local LATIN_ONLY_FACE = {
    ["Friz Quadrata"] = true,
    ["Arial Narrow"]  = true,
    ["Skurri"]        = true,
    ["Morpheus"]      = true,
}

local clientNeedsNonLatin = NON_LATIN_LOCALE[GetLocale()] or false

-- True when `faceName` would render as empty boxes on this client. The options
-- dropdown uses this to say so; Media:Fetch uses it to quietly substitute.
function Media:IsUnreadableFace(faceName)
    return clientNeedsNonLatin and LATIN_ONLY_FACE[faceName] or false
end

-- Our media kind -> LibSharedMedia media type.
local LSM_KIND = {
    statusbar  = "statusbar",
    font       = "font",
    background = "background",
    border     = "border",
    sound      = "sound",
}

--------------------------------------------------------------------------------
-- BUILT-IN ASSETS
--------------------------------------------------------------------------------
Media.builtin = {
    -- Bar fill textures.
    statusbar = {
        ["Flat"]            = [[Interface\Buttons\WHITE8X8]],
        ["Solid"]           = [[Interface\ChatFrame\ChatFrameBackground]],
        ["Blizzard"]        = [[Interface\TargetingFrame\UI-StatusBar]],
        ["Blizzard Raid"]   = [[Interface\RaidFrame\Raid-Bar-Hp-Fill]],
        ["Blizzard Skills"] = [[Interface\PaperDollInfoFrame\UI-Character-Skills-Bar]],
        ["Gradient"]        = [[Interface\Buttons\GreyscaleRamp64]],
        ["Highlight"]       = [[Interface\Buttons\UI-Listbox-Highlight2]],
        ["Tooltip"]         = [[Interface\Tooltips\UI-Tooltip-Background]],
    },

    -- Panel / track fill textures.
    background = {
        ["Solid"]           = [[Interface\Buttons\WHITE8X8]],
        ["Chat"]            = [[Interface\ChatFrame\ChatFrameBackground]],
        ["Tooltip"]         = [[Interface\Tooltips\UI-Tooltip-Background]],
        ["Dialog"]          = [[Interface\DialogFrame\UI-DialogBox-Background]],
        ["Dialog Dark"]     = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]],
        ["Marble"]          = [[Interface\FrameGeneral\UI-Background-Marble]],
        ["Rock"]            = [[Interface\FrameGeneral\UI-Background-Rock]],
        ["Gradient"]        = [[Interface\Buttons\GreyscaleRamp64]],
    },

    -- Fonts. Blizzard ships these files with every client, but only "Game
    -- Default" is guaranteed to be able to *draw* the client's language -- the
    -- other four are Latin-only faces, and picking one on a Russian, Korean or
    -- Chinese client turns the panel into rows of empty boxes. Game Default is
    -- therefore both the first entry and the fallback.
    font = {
        ["Game Default"]    = false,   -- resolved per locale, see Media:UIFont()
        ["Friz Quadrata"]   = [[Fonts\FRIZQT__.TTF]],
        ["Arial Narrow"]    = [[Fonts\ARIALN.TTF]],
        ["Skurri"]          = [[Fonts\skurri.TTF]],
        ["Morpheus"]        = [[Fonts\MORPHEUS.TTF]],
    },
}

-- Border definitions carry their own natural edge size; "pixel" borders are the
-- ones that look correct at any thickness the user picks.
Media.borders = {
    ["None"]        = false,
    ["Pixel"]       = { edge = [[Interface\Buttons\WHITE8X8]],                edgeSize = 1,  pixel = true, inset = 0 },
    ["Tooltip"]     = { edge = [[Interface\Tooltips\UI-Tooltip-Border]],      edgeSize = 16, inset = 4 },
    ["Dialog"]      = { edge = [[Interface\DialogFrame\UI-DialogBox-Border]], edgeSize = 32, inset = 11 },
    ["Gold"]        = { edge = [[Interface\DialogFrame\UI-DialogBox-Gold-Border]], edgeSize = 32, inset = 11 },
    ["Glow"]        = { edge = [[Interface\Tooltips\UI-Tooltip-Border]],      edgeSize = 12, inset = 3 },
}

-- Font outline flag combinations, in dropdown order.
--
-- Only `name` is translated. `value` is what SetFont expects and what lands in
-- the saved profile, so it stays English on every client -- otherwise a profile
-- written on a German client would be unreadable on an English one. The same
-- rule governs the texture and border tables above: their keys are lookup keys
-- and LibSharedMedia registration names, not display text.
Media.fontFlags = {
    { value = "",                    name = L["None"] },
    { value = "OUTLINE",             name = L["Outline"] },
    { value = "THICKOUTLINE",        name = L["Thick Outline"] },
    { value = "MONOCHROME",          name = L["Monochrome"] },
    { value = "MONOCHROME,OUTLINE",  name = L["Monochrome Outline"] },
}

-- Frame strata values, ordered from back to front.
Media.strata = {
    "BACKGROUND", "LOW", "MEDIUM", "HIGH", "DIALOG", "FULLSCREEN",
    "FULLSCREEN_DIALOG", "TOOLTIP",
}

-- Fallback used whenever a saved name can't be resolved. The font fallback is
-- deliberately the locale-correct one: a shared-media font vanishing when its
-- addon is uninstalled must not drop a non-Latin client into boxes.
Media.fallback = {
    statusbar  = "Flat",
    background = "Solid",
    font       = "Game Default",
    border     = "Pixel",
}

--------------------------------------------------------------------------------
-- LOOKUP
--------------------------------------------------------------------------------

-- Sorted list of every available name for a media kind (built-in + shared media).
-- Cached until something registers new shared media.
local listCache = {}

function Media:List(kind)
    if listCache[kind] then return listCache[kind] end

    local seen, out = {}, {}
    local function add(name)
        if name and not seen[name] then
            seen[name] = true
            out[#out + 1] = name
        end
    end

    if kind == "border" then
        for name in pairs(self.borders) do add(name) end
    else
        for name in pairs(self.builtin[kind] or {}) do add(name) end
    end

    local lsmKind = LSM_KIND[kind]
    if LSM and lsmKind then
        for _, name in ipairs(LSM:List(lsmKind)) do add(name) end
    end

    table.sort(out, function(a, b) return a:lower() < b:lower() end)

    -- "None" always sorts to the top of the border list; it's the neutral choice.
    if kind == "border" then
        for i, name in ipairs(out) do
            if name == "None" and i > 1 then
                table.remove(out, i)
                table.insert(out, 1, "None")
                break
            end
        end
    end

    listCache[kind] = out
    return out
end

function Media:FlushCache()
    wipe(listCache)
end

-- Resolves a saved name to a file path, falling back to our default if the
-- name has gone missing.
function Media:Fetch(kind, name)
    -- A literal file path is taken as-is. This lets a preset borrow media
    -- straight from another addon (ElvUI, for one) without registering it.
    if type(name) == "string" and name:find("[\\/]") then
        return name
    end

    -- "Game Default" carries no path of its own; it means "whatever this client
    -- draws its own text with", which is only knowable at runtime.
    if kind == "font" and (name == nil or name == "Game Default"
        or self:IsUnreadableFace(name)) then
        return self:UIFont()
    end

    local builtin = self.builtin[kind]
    if builtin and name and builtin[name] then
        return builtin[name]
    end

    local lsmKind = LSM_KIND[kind]
    if LSM and lsmKind and name then
        local path = LSM:Fetch(lsmKind, name, true)
        if path then return path end
    end

    if kind == "font" then return self:UIFont() end

    return builtin and builtin[self.fallback[kind]] or nil
end

-- Border lookup returns a table (or nil for "None") so callers can build a
-- backdrop from it. `size` overrides edgeSize for pixel-style borders.
function Media:FetchBorder(name, size)
    if not name or name == "None" then return nil end

    local def = self.borders[name]
    if def then
        if def.pixel then
            local px = math.max(1, size or def.edgeSize)
            return { edge = def.edge, edgeSize = px, inset = px }
        end
        return { edge = def.edge, edgeSize = def.edgeSize, inset = def.inset }
    end

    if LSM then
        local path = LSM:Fetch("border", name, true)
        if path then
            local edgeSize = math.max(1, size or 12)
            return { edge = path, edgeSize = edgeSize, inset = math.floor(edgeSize / 3) }
        end
    end

    return nil
end

-- Applies a background + border combination to any frame. Handles the
-- BackdropTemplate mixin that retail requires for backdrops.
-- The frame must have been created with the "BackdropTemplate" mixin; retail
-- dropped the built-in backdrop API, so a plain frame has no SetBackdrop.
function Media:ApplyBackdrop(frame, opts)
    if not frame.SetBackdrop then return end

    local border = self:FetchBorder(opts.borderStyle, opts.borderSize)
    local bgFile = opts.bgTexture and self:Fetch("background", opts.bgTexture) or nil
    local inset = border and border.inset or 0
    if opts.borderInset then inset = inset + opts.borderInset end

    frame:SetBackdrop({
        bgFile   = bgFile,
        edgeFile = border and border.edge or nil,
        edgeSize = border and border.edgeSize or nil,
        tile     = opts.tile or false,
        tileSize = opts.tileSize or 32,
        insets   = { left = inset, right = inset, top = inset, bottom = inset },
    })

    local bg = opts.bgColor
    if bg then frame:SetBackdropColor(bg[1], bg[2], bg[3], bg[4] or 1) end

    local bc = opts.borderColor
    if border and bc then frame:SetBackdropBorderColor(bc[1], bc[2], bc[3], bc[4] or 1) end
end

-- Convenience: resolve a full font spec (face name + size + flags) at once.
-- Applies a font, returning false rather than erroring if it won't take.
--
-- Patch 12.0.7 added RequiresValidFontHeight and RequiresValidFontAsset to
-- SetFont, so an unreadable file or a nonsense size now RAISES instead of
-- quietly returning false. That is reachable in normal use: a shared-media font
-- disappears the moment the addon providing it is uninstalled, while the saved
-- profile still names it.
local function trySetFont(fontString, path, size, flags)
    if type(path) ~= "string" or path == "" then return false end
    if type(size) ~= "number" or size < 1 then return false end

    local ok, applied = pcall(fontString.SetFont, fontString, path, size, flags or "")
    return ok and applied ~= false
end

function Media:ApplyFont(fontString, faceName, size, flags, shadow)
    local path = self:Fetch("font", faceName)
    local fallback = self:UIFont()

    if not trySetFont(fontString, path, size, flags) then
        -- Try the built-in font, then a known-good size, before giving up.
        if not trySetFont(fontString, fallback, size, flags)
            and not trySetFont(fontString, fallback, 12, "") then
            return
        end
    end

    if shadow and shadow.enabled then
        local c = shadow.color or { 0, 0, 0, 1 }
        fontString:SetShadowColor(c[1], c[2], c[3], c[4] or 1)
        fontString:SetShadowOffset(shadow.x or 1, shadow.y or -1)
    else
        fontString:SetShadowColor(0, 0, 0, 0)
        fontString:SetShadowOffset(0, 0)
    end
end
