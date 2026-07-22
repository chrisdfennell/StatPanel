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

local Media = {}
SP.Media = Media

local LSM = _G.LibStub and _G.LibStub("LibSharedMedia-3.0", true)
Media.LSM = LSM

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

    -- Fonts. Blizzard ships these with every client and locale.
    font = {
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
Media.fontFlags = {
    { value = "",                    name = "None" },
    { value = "OUTLINE",             name = "Outline" },
    { value = "THICKOUTLINE",        name = "Thick Outline" },
    { value = "MONOCHROME",          name = "Monochrome" },
    { value = "MONOCHROME,OUTLINE",  name = "Monochrome Outline" },
}

-- Frame strata values, ordered from back to front.
Media.strata = {
    "BACKGROUND", "LOW", "MEDIUM", "HIGH", "DIALOG", "FULLSCREEN",
    "FULLSCREEN_DIALOG", "TOOLTIP",
}

-- Fallback used whenever a saved name can't be resolved.
Media.fallback = {
    statusbar  = "Flat",
    background = "Solid",
    font       = "Friz Quadrata",
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

    local builtin = self.builtin[kind]
    if builtin and name and builtin[name] then
        return builtin[name]
    end

    local lsmKind = LSM_KIND[kind]
    if LSM and lsmKind and name then
        local path = LSM:Fetch(lsmKind, name, true)
        if path then return path end
    end

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
function Media:ApplyFont(fontString, faceName, size, flags, shadow)
    local path = self:Fetch("font", faceName)
    local fallback = self.builtin.font[self.fallback.font]

    -- SetFont errors on a nil path and returns false on an unreadable file;
    -- either way fall back rather than blanking the text out.
    if not path or not fontString:SetFont(path, size, flags or "") then
        fontString:SetFont(fallback, size, flags or "")
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
