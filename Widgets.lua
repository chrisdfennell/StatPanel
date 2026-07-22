-- Widgets.lua (Reusable option controls)
--
-- Built from plain frames and textures rather than Blizzard's option templates.
-- Those templates have been renamed or removed repeatedly across expansions
-- (InterfaceOptionsCheckButtonTemplate, UIDropDownMenu, OptionsSliderTemplate),
-- so owning the widgets keeps the options panel working across patches.
--
-- Every widget binds to a config path and knows how to re-read itself, which is
-- what lets a preset or profile switch refresh the whole panel at once.

local addonName, SP = ...

local UI = {}
SP.UI = UI

local Media = SP.Media
local Config = SP.Config

UI.ROW_HEIGHT = 24
UI.GAP        = 6

-- Every widget registers here so :RefreshAll() can re-sync the entire options
-- panel after a preset, profile switch or reset changes values underneath it.
UI.widgets = {}

local function register(widget, refresh)
    widget.Refresh = refresh
    UI.widgets[#UI.widgets + 1] = widget
    return widget
end

function UI:RefreshAll()
    for _, widget in ipairs(self.widgets) do
        if widget.Refresh and widget:IsObjectType("Frame") then
            widget:Refresh()
        end
    end
end

--------------------------------------------------------------------------------
-- SHARED HELPERS
--------------------------------------------------------------------------------
local function attachTooltip(frame, title, text)
    if not title and not text then return end
    frame:HookScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        if title then GameTooltip:AddLine(title, 1, 1, 1) end
        if text then GameTooltip:AddLine(text, 0.8, 0.8, 0.8, true) end
        GameTooltip:Show()
    end)
    frame:HookScript("OnLeave", function() GameTooltip:Hide() end)
end

-- Binds a widget to either an explicit get/set pair or a config path.
local function binding(opts)
    local get = opts.get
    local set = opts.set

    if not get and opts.path then
        get = function() return Config:Get(opts.path) end
    end
    if not set and opts.path then
        set = function(value) Config:Set(opts.path, value) end
    end

    return get or function() end, function(value)
        if set then set(value) end
        if opts.onChange then opts.onChange(value) end
    end
end

-- Previews show fonts the user may not have installed, and 12.0.7 made SetFont
-- raise on an unreadable asset rather than return false. Fall back to the
-- default font instead of letting a dropdown row take the options panel down.
local function safeSetFont(fontString, path, size, flags)
    if type(path) == "string" and path ~= "" then
        local ok, applied = pcall(fontString.SetFont, fontString, path, size, flags or "")
        if ok and applied ~= false then return true end
    end
    pcall(fontString.SetFont, fontString, [[Fonts\FRIZQT__.TTF]], size, flags or "")
    return false
end

local function newFontString(parent, size, r, g, b)
    local fs = parent:CreateFontString(nil, "OVERLAY")
    fs:SetFont([[Fonts\FRIZQT__.TTF]], size or 12, "")
    fs:SetTextColor(r or 0.9, g or 0.9, b or 0.9)
    return fs
end

--------------------------------------------------------------------------------
-- STACK (vertical auto-layout)
--------------------------------------------------------------------------------
-- Positioning ~200 controls by hand would be unmaintainable, so widgets are
-- pushed onto a stack that walks down the container.
local Stack = {}
Stack.__index = Stack

function UI:NewStack(parent, x, yStart, width)
    return setmetatable({
        parent = parent,
        x = x or 16,
        y = yStart or -16,
        width = width or (parent:GetWidth() - 32),
        indent = 0,
    }, Stack)
end

function Stack:Add(widget, height)
    widget:ClearAllPoints()
    widget:SetPoint("TOPLEFT", self.parent, "TOPLEFT", self.x + self.indent, self.y)

    -- Anchoring both sides rather than setting a width keeps every control
    -- correct even though the Settings canvas only gets its real size after
    -- the page has already been built.
    if not widget.fixedWidth then
        widget:SetPoint("TOPRIGHT", self.parent, "TOPRIGHT", -4, self.y)
    end

    self.y = self.y - (height or widget:GetHeight() or UI.ROW_HEIGHT) - UI.GAP
    return widget
end

function Stack:Gap(amount)
    self.y = self.y - (amount or UI.GAP)
end

function Stack:Indent(amount)
    self.indent = math.max(0, self.indent + (amount or 16))
end

function Stack:Height()
    return -self.y + 16
end

--------------------------------------------------------------------------------
-- HEADER / SEPARATOR
--------------------------------------------------------------------------------
function UI:Header(parent, text)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetHeight(22)

    frame.text = newFontString(frame, 13, 1, 0.82, 0.32)
    frame.text:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 4)
    frame.text:SetText(text)

    local line = frame:CreateTexture(nil, "ARTWORK")
    line:SetColorTexture(1, 0.82, 0.32, 0.25)
    line:SetHeight(1)
    line:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
    line:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)

    return frame
end

function UI:Note(parent, text)
    text = text or ""

    local frame = CreateFrame("Frame", nil, parent)
    frame.text = newFontString(frame, 11, 0.6, 0.6, 0.65)
    frame.text:SetPoint("TOPLEFT")
    frame.text:SetPoint("TOPRIGHT")
    frame.text:SetJustifyH("LEFT")
    frame.text:SetWordWrap(true)
    frame.text:SetText(text)

    -- Height is estimated from the text rather than measured. The layout stack
    -- needs a height the moment the widget is added, which is before the
    -- Settings canvas has resolved a real width for anything to wrap against.
    local lines = 1
    for _ in text:gmatch("\n") do lines = lines + 1 end
    lines = lines + math.floor(#text / 70)
    frame:SetHeight(lines * 14 + 2)

    return frame
end

--------------------------------------------------------------------------------
-- CHECKBOX
--------------------------------------------------------------------------------
function UI:Check(parent, opts)
    local get, set = binding(opts)

    local frame = CreateFrame("Frame", nil, parent)
    frame:SetHeight(UI.ROW_HEIGHT)

    local button = CreateFrame("CheckButton", nil, frame)
    button:SetSize(22, 22)
    button:SetPoint("LEFT", frame, "LEFT", 0, 0)
    button:SetNormalTexture([[Interface\Buttons\UI-CheckBox-Up]])
    button:SetPushedTexture([[Interface\Buttons\UI-CheckBox-Down]])
    button:SetHighlightTexture([[Interface\Buttons\UI-CheckBox-Highlight]], "ADD")
    button:SetCheckedTexture([[Interface\Buttons\UI-CheckBox-Check]])
    button:SetDisabledCheckedTexture([[Interface\Buttons\UI-CheckBox-Check-Disabled]])

    local label = newFontString(frame, 12)
    label:SetPoint("LEFT", button, "RIGHT", 4, 0)
    label:SetText(opts.label or "")

    button:SetScript("OnClick", function(self)
        local checked = self:GetChecked() and true or false
        set(checked)
        if opts.refreshAll then UI:RefreshAll() end
    end)

    attachTooltip(button, opts.label, opts.tooltip)
    frame.button = button

    return register(frame, function(self)
        self.button:SetChecked(get() and true or false)
    end)
end

--------------------------------------------------------------------------------
-- SLIDER
--------------------------------------------------------------------------------
function UI:Slider(parent, opts)
    local get, set = binding(opts)
    local decimals = opts.decimals or 0

    local frame = CreateFrame("Frame", nil, parent)
    frame:SetHeight(40)

    local label = newFontString(frame, 12)
    label:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    label:SetText(opts.label or "")

    local readout = newFontString(frame, 12, 1, 0.82, 0.32)
    readout:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)

    local slider = CreateFrame("Slider", nil, frame)
    slider:SetHeight(16)
    slider:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -18)
    slider:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -18)
    slider:SetOrientation("HORIZONTAL")
    slider:SetMinMaxValues(opts.min or 0, opts.max or 100)
    slider:SetValueStep(opts.step or 1)
    slider:SetObeyStepOnDrag(true)
    slider:SetThumbTexture([[Interface\Buttons\UI-SliderBar-Button-Horizontal]])

    local track = slider:CreateTexture(nil, "BACKGROUND")
    track:SetColorTexture(0, 0, 0, 0.55)
    track:SetHeight(5)
    track:SetPoint("LEFT", slider, "LEFT", 0, 0)
    track:SetPoint("RIGHT", slider, "RIGHT", 0, 0)

    local fill = slider:CreateTexture(nil, "BORDER")
    fill:SetColorTexture(0.35, 0.55, 0.85, 0.75)
    fill:SetHeight(5)
    fill:SetPoint("LEFT", track, "LEFT", 0, 0)

    local function updateVisual(value)
        readout:SetText(string.format("%." .. decimals .. "f%s", value, opts.suffix or ""))
        local min, max = slider:GetMinMaxValues()
        local pct = (max > min) and ((value - min) / (max - min)) or 0
        fill:SetWidth(math.max(1, pct * slider:GetWidth()))
    end

    slider:SetScript("OnValueChanged", function(self, value, userInput)
        -- Snap to the step so float drift doesn't creep into saved settings.
        local step = opts.step or 1
        value = math.floor(value / step + 0.5) * step
        updateVisual(value)
        if userInput then set(value) end
    end)

    attachTooltip(slider, opts.label, opts.tooltip)
    frame.slider = slider

    return register(frame, function(self)
        local value = tonumber(get()) or opts.min or 0
        self.slider:SetValue(value)
        updateVisual(value)
    end)
end

--------------------------------------------------------------------------------
-- DROPDOWN
--------------------------------------------------------------------------------
-- One shared popup serves every dropdown.
local menu

local function createMenu()
    if menu then return menu end

    menu = CreateFrame("Frame", "SPAddonDropdownMenu", UIParent, "BackdropTemplate")
    menu:SetFrameStrata("FULLSCREEN_DIALOG")
    menu:SetSize(200, 100)
    menu:SetBackdrop({
        bgFile = [[Interface\Buttons\WHITE8X8]],
        edgeFile = [[Interface\Buttons\WHITE8X8]],
        edgeSize = 1,
    })
    menu:SetBackdropColor(0.05, 0.05, 0.06, 0.97)
    menu:SetBackdropBorderColor(0.4, 0.4, 0.45, 1)
    menu:Hide()

    menu.scroll = CreateFrame("ScrollFrame", nil, menu)
    menu.scroll:SetPoint("TOPLEFT", 4, -4)
    menu.scroll:SetPoint("BOTTOMRIGHT", -4, 4)

    menu.content = CreateFrame("Frame", nil, menu.scroll)
    menu.content:SetSize(1, 1)
    menu.scroll:SetScrollChild(menu.content)

    menu.buttons = {}

    menu:EnableMouseWheel(true)
    menu:SetScript("OnMouseWheel", function(self, delta)
        local current = self.scroll:GetVerticalScroll()
        local maxScroll = math.max(0, self.contentHeight - self.scroll:GetHeight())
        self.scroll:SetVerticalScroll(math.max(0, math.min(maxScroll, current - delta * 30)))
    end)

    -- Clicking anywhere else closes the menu.
    menu:SetScript("OnShow", function(self)
        self.closer = self.closer or CreateFrame("Frame", nil, UIParent)
        self.closer:SetAllPoints(UIParent)
        self.closer:SetFrameStrata("FULLSCREEN")
        self.closer:EnableMouse(true)
        self.closer:SetScript("OnMouseDown", function() menu:Hide() end)
        self.closer:Show()
    end)
    menu:SetScript("OnHide", function(self)
        if self.closer then self.closer:Hide() end
    end)

    return menu
end

local MENU_ROW = 20

local function openMenu(owner, values, current, onSelect, preview)
    local m = createMenu()
    m.owner = owner

    for _, button in ipairs(m.buttons) do button:Hide() end

    local width = math.max(owner:GetWidth(), 160)
    local y = 0

    for index, entry in ipairs(values) do
        local value = type(entry) == "table" and entry.value or entry
        local text  = type(entry) == "table" and entry.name or tostring(entry)

        local button = m.buttons[index]
        if not button then
            button = CreateFrame("Button", nil, m.content)
            button:SetHeight(MENU_ROW)

            button.preview = button:CreateTexture(nil, "BACKGROUND")
            button.preview:SetAllPoints(button)

            button.highlight = button:CreateTexture(nil, "HIGHLIGHT")
            button.highlight:SetAllPoints(button)
            button.highlight:SetColorTexture(0.35, 0.55, 0.85, 0.35)

            button.text = newFontString(button, 12)
            button.text:SetPoint("LEFT", button, "LEFT", 6, 0)
            button.text:SetJustifyH("LEFT")

            button.check = button:CreateTexture(nil, "OVERLAY")
            button.check:SetTexture([[Interface\Buttons\UI-CheckBox-Check]])
            button.check:SetSize(16, 16)
            button.check:SetPoint("RIGHT", button, "RIGHT", -2, 0)

            m.buttons[index] = button
        end

        button:SetWidth(width - 8)
        button:SetPoint("TOPLEFT", m.content, "TOPLEFT", 0, -y)

        -- Preview modes let you see the texture or font before choosing it.
        button.preview:SetVertexColor(1, 1, 1, 1)
        if preview == "statusbar" or preview == "background" then
            button.preview:SetTexture(Media:Fetch(preview, value))
            button.preview:SetVertexColor(0.45, 0.55, 0.75, 0.9)
            button.preview:Show()
            button.text:SetFont([[Fonts\FRIZQT__.TTF]], 12, "OUTLINE")
        elseif preview == "font" then
            button.preview:Hide()
            safeSetFont(button.text, Media:Fetch("font", value), 13, "")
        else
            button.preview:Hide()
            button.text:SetFont([[Fonts\FRIZQT__.TTF]], 12, "")
        end

        button.text:SetText(text)
        button.check:SetShown(value == current)

        button:SetScript("OnClick", function()
            m:Hide()
            onSelect(value)
        end)

        button:Show()
        y = y + MENU_ROW
    end

    local height = math.min(y + 8, 320)
    m.contentHeight = y
    m:SetSize(width, height)
    m.content:SetSize(width - 8, y)
    m.scroll:SetVerticalScroll(0)

    m:ClearAllPoints()
    m:SetPoint("TOPLEFT", owner, "BOTTOMLEFT", 0, -2)
    m:Show()
end

function UI:Dropdown(parent, opts)
    local get, set = binding(opts)

    local frame = CreateFrame("Frame", nil, parent)
    frame:SetHeight(42)

    local label = newFontString(frame, 12)
    label:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    label:SetText(opts.label or "")

    local button = CreateFrame("Button", nil, frame, "BackdropTemplate")
    button:SetHeight(22)
    button:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -18)
    button:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -18)
    button:SetBackdrop({
        bgFile = [[Interface\Buttons\WHITE8X8]],
        edgeFile = [[Interface\Buttons\WHITE8X8]],
        edgeSize = 1,
    })
    button:SetBackdropColor(0.10, 0.10, 0.12, 0.9)
    button:SetBackdropBorderColor(0.35, 0.35, 0.40, 1)

    button.text = newFontString(button, 12)
    button.text:SetPoint("LEFT", button, "LEFT", 6, 0)
    button.text:SetPoint("RIGHT", button, "RIGHT", -20, 0)
    button.text:SetJustifyH("LEFT")

    local arrow = button:CreateTexture(nil, "OVERLAY")
    arrow:SetTexture([[Interface\Buttons\Arrow-Down-Up]])
    arrow:SetSize(16, 16)
    arrow:SetPoint("RIGHT", button, "RIGHT", -2, -1)

    button:SetScript("OnEnter", function(self) self:SetBackdropBorderColor(0.6, 0.7, 0.9, 1) end)
    button:SetScript("OnLeave", function(self) self:SetBackdropBorderColor(0.35, 0.35, 0.40, 1) end)

    button:SetScript("OnClick", function(self)
        if menu and menu:IsShown() and menu.owner == self then
            menu:Hide()
            return
        end
        local values = type(opts.values) == "function" and opts.values() or opts.values
        openMenu(self, values or {}, get(), function(value)
            set(value)
            frame:Refresh()
            if opts.refreshAll then UI:RefreshAll() end
        end, opts.preview)
    end)

    attachTooltip(button, opts.label, opts.tooltip)
    frame.button = button

    return register(frame, function(self)
        local current = get()
        local values = type(opts.values) == "function" and opts.values() or opts.values

        -- Prefer the display name when the list uses {name, value} pairs.
        local display = current
        for _, entry in ipairs(values or {}) do
            if type(entry) == "table" and entry.value == current then
                display = entry.name
                break
            end
        end
        self.button.text:SetText(display ~= nil and tostring(display) or "")

        if opts.preview == "font" then
            safeSetFont(self.button.text, Media:Fetch("font", current), 13, "")
        end
    end)
end

--------------------------------------------------------------------------------
-- COLOR SWATCH
--------------------------------------------------------------------------------
function UI:Color(parent, opts)
    local hasAlpha = opts.hasAlpha ~= false

    local function getColor()
        if opts.get then return opts.get() end
        return Config:GetColor(opts.path)
    end

    local function setColor(r, g, b, a)
        if opts.set then
            opts.set(r, g, b, a)
            SP:Refresh()
        else
            Config:SetColor(opts.path, r, g, b, a)
        end
        if opts.onChange then opts.onChange() end
    end

    local frame = CreateFrame("Frame", nil, parent)
    frame:SetHeight(UI.ROW_HEIGHT)

    local swatch = CreateFrame("Button", nil, frame, "BackdropTemplate")
    swatch:SetSize(34, 18)
    swatch:SetPoint("LEFT", frame, "LEFT", 0, 0)
    swatch:SetBackdrop({
        bgFile = [[Interface\Buttons\WHITE8X8]],
        edgeFile = [[Interface\Buttons\WHITE8X8]],
        edgeSize = 1,
    })
    swatch:SetBackdropBorderColor(0.5, 0.5, 0.55, 1)

    -- A checkerboard behind the swatch makes transparency visible.
    local checker = swatch:CreateTexture(nil, "BACKGROUND")
    checker:SetPoint("TOPLEFT", 1, -1)
    checker:SetPoint("BOTTOMRIGHT", -1, 1)
    checker:SetTexture([[Interface\Buttons\UI-CheckBox-Up]])
    checker:SetVertexColor(0.35, 0.35, 0.35, 1)

    local label = newFontString(frame, 12)
    label:SetPoint("LEFT", swatch, "RIGHT", 8, 0)
    label:SetText(opts.label or "")

    swatch:SetScript("OnClick", function()
        local r, g, b, a = getColor()

        local function onChanged()
            local newR, newG, newB = ColorPickerFrame:GetColorRGB()
            local newA = 1
            if hasAlpha then
                if ColorPickerFrame.GetColorAlpha then
                    newA = ColorPickerFrame:GetColorAlpha()
                elseif OpacitySliderFrame then
                    newA = 1 - OpacitySliderFrame:GetValue()
                end
            end
            setColor(newR, newG, newB, newA)
            frame:Refresh()
        end

        local info = {
            swatchFunc  = onChanged,
            opacityFunc = onChanged,
            hasOpacity  = hasAlpha,
            opacity     = a,
            r = r, g = g, b = b,
            cancelFunc  = function()
                setColor(r, g, b, a)
                frame:Refresh()
            end,
        }

        if ColorPickerFrame.SetupColorPickerAndShow then
            ColorPickerFrame:SetupColorPickerAndShow(info)
        else
            -- Pre-10.0 fallback; harmless to keep and cheap insurance.
            ColorPickerFrame.func = info.swatchFunc
            ColorPickerFrame.opacityFunc = info.opacityFunc
            ColorPickerFrame.cancelFunc = info.cancelFunc
            ColorPickerFrame.hasOpacity = hasAlpha
            ColorPickerFrame.opacity = a
            ColorPickerFrame:SetColorRGB(r, g, b)
            ColorPickerFrame:Show()
        end
    end)

    attachTooltip(swatch, opts.label, opts.tooltip or "Click to choose a color.")
    frame.swatch = swatch

    return register(frame, function(self)
        local r, g, b, a = getColor()
        self.swatch:SetBackdropColor(r, g, b, a)
    end)
end

--------------------------------------------------------------------------------
-- EDIT BOX
--------------------------------------------------------------------------------
function UI:EditBox(parent, opts)
    local get, set = binding(opts)

    local frame = CreateFrame("Frame", nil, parent)
    frame:SetHeight(opts.multiline and 96 or 44)

    local label = newFontString(frame, 12)
    label:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    label:SetText(opts.label or "")

    local box = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    box:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -18)
    box:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
    box:SetBackdrop({
        bgFile = [[Interface\Buttons\WHITE8X8]],
        edgeFile = [[Interface\Buttons\WHITE8X8]],
        edgeSize = 1,
    })
    box:SetBackdropColor(0.06, 0.06, 0.08, 0.9)
    box:SetBackdropBorderColor(0.35, 0.35, 0.40, 1)

    local edit = CreateFrame("EditBox", nil, box)
    edit:SetPoint("TOPLEFT", 5, -3)
    edit:SetPoint("BOTTOMRIGHT", -5, 3)
    edit:SetAutoFocus(false)
    edit:SetFontObject(ChatFontNormal)
    edit:SetTextInsets(0, 0, 0, 0)
    edit:SetMultiLine(opts.multiline or false)
    if opts.maxLetters then edit:SetMaxLetters(opts.maxLetters) end

    edit:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
        frame:Refresh()
    end)

    if not opts.multiline then
        edit:SetScript("OnEnterPressed", function(self)
            set(self:GetText())
            self:ClearFocus()
        end)
    end

    edit:SetScript("OnEditFocusLost", function(self)
        if not opts.manualCommit then set(self:GetText()) end
    end)

    -- Select-all makes export strings easy to copy out.
    edit:SetScript("OnMouseUp", function(self)
        if opts.selectAllOnClick then self:HighlightText() end
    end)

    attachTooltip(box, opts.label, opts.tooltip)
    frame.edit = edit

    return register(frame, function(self)
        if self.edit:HasFocus() then return end
        self.edit:SetText(tostring(get() or ""))
        self.edit:SetCursorPosition(0)
    end)
end

--------------------------------------------------------------------------------
-- BUTTON
--------------------------------------------------------------------------------
function UI:Button(parent, opts)
    local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    button:SetSize(opts.width or 130, opts.height or 22)
    button.fixedWidth = true
    button:SetText(opts.text or "")
    button:SetScript("OnClick", function()
        if opts.onClick then opts.onClick() end
    end)
    attachTooltip(button, opts.text, opts.tooltip)
    return button
end

-- Places several buttons side by side on one row.
function UI:ButtonRow(parent, buttons)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetHeight(26)

    local x = 0
    for _, opts in ipairs(buttons) do
        local button = UI:Button(frame, opts)
        button:SetPoint("LEFT", frame, "LEFT", x, 0)
        x = x + (opts.width or 130) + 6
    end
    return frame
end

--------------------------------------------------------------------------------
-- SCROLLING CONTAINER
--------------------------------------------------------------------------------
-- A scroll area with a slim custom scrollbar. Blizzard's scroll templates have
-- churned as much as the option templates, so this is hand-rolled too.
function UI:ScrollArea(parent)
    local scroll = CreateFrame("ScrollFrame", nil, parent)

    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(1, 1)
    scroll:SetScrollChild(content)

    local bar = CreateFrame("Frame", nil, scroll)
    bar:SetWidth(4)
    bar:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -2, 0)
    bar:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -2, 0)

    local barBG = bar:CreateTexture(nil, "BACKGROUND")
    barBG:SetAllPoints(bar)
    barBG:SetColorTexture(1, 1, 1, 0.05)

    local thumb = bar:CreateTexture(nil, "ARTWORK")
    thumb:SetColorTexture(0.5, 0.55, 0.65, 0.6)
    thumb:SetWidth(4)
    thumb:SetPoint("TOP", bar, "TOP", 0, 0)

    local function updateThumb()
        local viewHeight = scroll:GetHeight()
        local total = content.totalHeight or viewHeight
        if total <= viewHeight then
            bar:Hide()
            return
        end
        bar:Show()

        local ratio = viewHeight / total
        local thumbHeight = math.max(20, viewHeight * ratio)
        thumb:SetHeight(thumbHeight)

        local scrolled = scroll:GetVerticalScroll()
        local maxScroll = total - viewHeight
        local pct = maxScroll > 0 and (scrolled / maxScroll) or 0
        thumb:SetPoint("TOP", bar, "TOP", 0, -pct * (viewHeight - thumbHeight))
    end

    scroll:EnableMouseWheel(true)
    scroll:SetScript("OnMouseWheel", function(self, delta)
        local total = content.totalHeight or self:GetHeight()
        local maxScroll = math.max(0, total - self:GetHeight())
        local target = math.max(0, math.min(maxScroll, self:GetVerticalScroll() - delta * 40))
        self:SetVerticalScroll(target)
        updateThumb()
    end)

    scroll.content = content
    scroll.UpdateScroll = updateThumb

    content.SetTotalHeight = function(self, height)
        self.totalHeight = height
        self:SetHeight(height)
        updateThumb()
    end

    return scroll, content
end
