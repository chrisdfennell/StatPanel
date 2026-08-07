-- Diagnostics.lua (/sp debug)
--
-- CONTRIBUTING.md asks bug reporters for the full error text, the addon
-- version, the game version, and whether other addons are loaded. Asking is not
-- the same as receiving: what actually arrives is a screenshot of one line.
--
-- This produces the whole set in one command, in a box the reporter can select
-- and paste. Everything here is read-only and local -- nothing is sent anywhere,
-- and the report deliberately carries no character or realm name, because the
-- usual destination is a public issue tracker.

local addonName, SP = ...
local L = SP.L

local Diagnostics = {}
SP.Diagnostics = Diagnostics

local function yesno(value)
    return value and L["yes"] or L["no"]
end

-- Reports a library's presence and version without requiring it. LibStub itself
-- is optional here: with no library-providing addon installed there is no
-- LibStub at all, which is a supported configuration and worth stating.
local function libVersion(name)
    if not _G.LibStub then return L["LibStub not present"] end
    local lib, minor = _G.LibStub(name, true)
    if not lib then return L["absent"] end
    return L["present (revision %s)"]:format(tostring(minor or "?"))
end

-- Whether the client is protecting combat statistics right now. This is the
-- single most useful line in the report: it decides which features are
-- expected to degrade, and it changes between patches without an addon update.
local function secretStatus()
    if not _G.issecretvalue then return L["not present in this client"] end

    local ok, secret = pcall(function()
        return SP.IsSecret(GetCritChance())
    end)
    if not ok then return L["present, could not sample"] end
    return secret and L["active (crit chance is protected)"]
        or L["present but crit chance is readable"]
end

function Diagnostics:Report()
    local lines = {}
    local function add(label, value)
        lines[#lines + 1] = label .. ": " .. tostring(value)
    end
    local function blank() lines[#lines + 1] = "" end

    local version = (C_AddOns and C_AddOns.GetAddOnMetadata
        and C_AddOns.GetAddOnMetadata(addonName, "Version")) or "?"
    local build, buildNumber, _, interfaceVersion = GetBuildInfo()

    -- Not routed through SP.L: the addon's name is a proper noun and is left
    -- untranslated everywhere, including the per-locale TOC headers.
    add("StatPanel", version)
    add(L["Game"], string.format("%s (%s), interface %s",
        tostring(build), tostring(buildNumber), tostring(interfaceVersion)))
    add(L["Locale"], GetLocale())

    blank()
    local _, class = UnitClass("player")
    local specIndex = GetSpecialization and GetSpecialization()
    local specID, specName
    if specIndex then specID, specName = GetSpecializationInfo(specIndex) end
    add(L["Class"], string.format("%s, level %s", tostring(class), tostring(UnitLevel("player"))))
    add(L["Spec"], string.format("%s (%s)", tostring(specName or "?"), tostring(specID or "?")))
    add(L["Secret values"], secretStatus())

    blank()
    add(L["Profile"], SP.Config:CurrentProfile())
    add(L["Profiles stored"], #SP.Config:ProfileList())
    add(L["Custom stat priority"], yesno(next(SP.db.customPriority or {}) ~= nil))

    blank()
    local panel = SP.db.panel
    add(L["Panel"], string.format("%s, %s, scale %.2f, %s",
        SP.db.enabled and L["enabled"] or L["disabled"],
        panel.locked and L["locked"] or L["unlocked"],
        panel.scale or 1,
        panel.autoWidth and L["auto width"] or string.format(L["width %d"], panel.width or 0)))
    add(L["Position"], string.format("%s %.0f, %.0f",
        tostring(panel.pos and panel.pos.point or "?"),
        (panel.pos and panel.pos.x) or 0, (panel.pos and panel.pos.y) or 0))
    add(L["Row style"], SP.db.bars.style)

    -- Which font is asked for and which one is actually drawn. These differ on
    -- a Korean or Chinese client, and that difference explains a whole class of
    -- "my panel is full of boxes" report.
    local face = SP.db.font.face
    add(L["Font"], string.format("%s -> %s%s",
        tostring(face), tostring(SP.Media:Fetch("font", face)),
        SP.Media:IsUnreadableFace(face) and L[" (substituted: not readable in this locale)"] or ""))

    blank()
    local enabled, total = 0, 0
    for _, section in ipairs(SP.db.sections or {}) do
        for _, statName in ipairs(section.stats or {}) do
            total = total + 1
            local cfg = SP.db.stats[statName]
            if section.enabled and cfg and cfg.enabled then enabled = enabled + 1 end
        end
    end
    add(L["Sections"], #(SP.db.sections or {}))
    add(L["Stat rows"], string.format(L["%d shown of %d placed"], enabled, total))

    blank()
    add("LibSharedMedia-3.0", libVersion("LibSharedMedia-3.0"))
    add("LibDataBroker-1.1", libVersion("LibDataBroker-1.1"))
    add("LibDBIcon-1.0", libVersion("LibDBIcon-1.0"))
    add("ElvUI", yesno(_G.ElvUI ~= nil))

    return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- THE COPY BOX
--------------------------------------------------------------------------------
-- Built from raw frames for the same reason Widgets.lua is: every options
-- template this could have used has been deprecated or removed at some point.
local frame

local function createFrame()
    local f = CreateFrame("Frame", "StatPanelDiagnostics", UIParent, "BackdropTemplate")
    f:SetSize(520, 420)
    f:SetPoint("CENTER")
    f:SetFrameStrata("DIALOG")
    f:EnableMouse(true)
    f:SetMovable(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)

    SP.Media:ApplyBackdrop(f, {
        bgTexture = "Solid", bgColor = { 0.05, 0.05, 0.06, 0.95 },
        borderStyle = "Pixel", borderColor = { 0.4, 0.4, 0.45, 1 }, borderSize = 1,
    })

    f.title = f:CreateFontString(nil, "OVERLAY")
    f.title:SetFont(SP.UIFont(), 14, "OUTLINE")
    f.title:SetPoint("TOPLEFT", 14, -12)
    f.title:SetText(L["StatPanel diagnostics"])

    f.hint = f:CreateFontString(nil, "OVERLAY")
    f.hint:SetFont(SP.UIFont(), 11, "")
    f.hint:SetPoint("TOPLEFT", 14, -32)
    f.hint:SetTextColor(0.7, 0.72, 0.76)
    f.hint:SetText(L["Ctrl-A to select all, Ctrl-C to copy. Paste this into your bug report."])

    local close = CreateFrame("Button", nil, f)
    close:SetSize(22, 22)
    close:SetPoint("TOPRIGHT", -8, -8)
    close.text = close:CreateFontString(nil, "OVERLAY")
    close.text:SetFont(SP.UIFont(), 16, "OUTLINE")
    close.text:SetPoint("CENTER")
    close.text:SetText("x")
    close:SetScript("OnClick", function() f:Hide() end)

    local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 14, -54)
    scroll:SetPoint("BOTTOMRIGHT", -30, 14)

    f.edit = CreateFrame("EditBox", nil, scroll)
    f.edit:SetMultiLine(true)
    f.edit:SetAutoFocus(false)
    f.edit:SetFontObject("ChatFontNormal")
    f.edit:SetWidth(460)
    -- Read-only in practice: the text is restored the moment anything is typed,
    -- so a stray keypress can't silently corrupt what gets pasted into a report.
    f.edit:SetScript("OnTextChanged", function(self, userInput)
        if userInput then self:SetText(self.reportText or "") self:HighlightText() end
    end)
    f.edit:SetScript("OnEscapePressed", function() f:Hide() end)
    scroll:SetScrollChild(f.edit)

    tinsert(_G.UISpecialFrames, "StatPanelDiagnostics")   -- Escape closes it
    return f
end

function Diagnostics:Show()
    local report = self:Report()

    frame = frame or createFrame()
    frame.edit.reportText = report
    frame.edit:SetText(report)
    frame:Show()
    frame.edit:HighlightText()
    frame.edit:SetFocus()

    return report
end

--------------------------------------------------------------------------------
-- WHAT'S NEW
--------------------------------------------------------------------------------
-- A changelog nobody reads is a changelog nobody reads. Print the highlights
-- once, the first time a new version runs, and never again.
--
-- Deliberately printed to chat rather than shown as a popup: a modal on login
-- is an interruption, and by the time most people log in they are already
-- doing something. The stamp lives in db.global so it is account-wide -- one
-- notice, not one per alt.
--
-- Highlights are keyed by version and only the entries NEWER than what the
-- user last saw are printed, so someone skipping three releases sees all
-- three. Old entries are kept until they age out of relevance.
--
-- Lines are printed raw, never passed through :format(), so a literal percent
-- would have to be written as one -- doubling it would print two. Avoid
-- percent signs here regardless: "1% of" reads as the %o specifier to the
-- locale linter, and a translator has no way to know that.
local HIGHLIGHTS = {
    { version = "2.5.0", lines = {
        L["Key bindings for toggling, locking, cycling profiles and the gear audit."],
        L["New stats: attack power, spell power, health, mana and stagger."],
        L["The $per token shows what one percent of a stat costs in rating."],
        L["Gear durability and repair cost can now sit in the footer."],
        L["A Colorblind Safe preset, and precise X/Y position controls."],
        L["/sp debug collects everything a bug report needs into one copyable box."],
    } },
}
Diagnostics.HIGHLIGHTS = HIGHLIGHTS

-- Compares dotted version strings numerically, so 2.10.0 sorts above 2.9.0.
-- A plain string comparison gets that backwards, which would silently stop the
-- notice from ever appearing again after the tenth minor release.
local function isNewer(a, b)
    local aParts, bParts = {}, {}
    for part in tostring(a):gmatch("%d+") do aParts[#aParts + 1] = tonumber(part) end
    for part in tostring(b):gmatch("%d+") do bParts[#bParts + 1] = tonumber(part) end

    for i = 1, math.max(#aParts, #bParts) do
        local x, y = aParts[i] or 0, bParts[i] or 0
        if x ~= y then return x > y end
    end
    return false
end
Diagnostics.IsNewerVersion = isNewer

function Diagnostics:ShowWhatsNew()
    local db = SPAddonDB and SPAddonDB.global
    if not db then return end

    local current = (C_AddOns and C_AddOns.GetAddOnMetadata
        and C_AddOns.GetAddOnMetadata(addonName, "Version")) or nil
    if not current then return end

    local seen = db.lastSeenVersion

    -- A database with no stamp at all is a fresh install as far as this can
    -- tell. Stamp it and say nothing: a new user has no "what's new".
    if not seen then
        db.lastSeenVersion = current
        return
    end

    if not isNewer(current, seen) then return end
    db.lastSeenVersion = current

    local printed = false
    for _, entry in ipairs(HIGHLIGHTS) do
        if isNewer(entry.version, seen) then
            if not printed then
                SP:Print(L["updated to %s. New in this version:"]:format(current))
                printed = true
            end
            for _, line in ipairs(entry.lines) do
                print("  |cffffd100-|r " .. line)
            end
        end
    end

    -- The URL is an argument, not part of the key: handing a translator a link
    -- to retype is how links get broken, and it would need re-translating in
    -- ten files if the repository ever moves.
    if printed then
        print(L["  Full changelog: %s"]:format(
            "https://github.com/chrisdfennell/StatPanel/blob/main/CHANGELOG.md"))
    end
end
