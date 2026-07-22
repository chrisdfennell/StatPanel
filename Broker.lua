-- Broker.lua (LibDataBroker feed + minimap button)
--
-- Exposes a LibDataBroker-1.1 data object if that library is present, so the
-- addon shows up in display bars like TitanPanel, Bazooka or ChocolateBar.
--
-- The minimap button is hand-rolled rather than depending on LibDBIcon-1.0, so
-- it works with zero embedded libraries. If LibDBIcon IS available we hand the
-- button off to it instead, since users expect all their minimap buttons to be
-- collected the same way.
--
-- Position and hidden state live in SPAddonDB.global (account-wide, not part of
-- a profile) so the button doesn't jump around when you switch looks.

local addonName, SP = ...

local Broker = {}
SP.Broker = Broker

local LDB      = LibStub and LibStub("LibDataBroker-1.1", true)
local LDBIcon  = LibStub and LibStub("LibDBIcon-1.0", true)

local ICON = [[Interface\Icons\INV_Misc_Gear_01]]

--------------------------------------------------------------------------------
-- SHARED BEHAVIOR
--------------------------------------------------------------------------------
-- Left-click opens options, right-click opens the context menu. Both the LDB
-- object and the custom button route through here.
local function onClick(owner, button)
    if button == "RightButton" then
        SP:ShowContextMenu(owner)
    else
        SP:OpenOptions()
    end
end

local function onTooltip(tooltip)
    if not tooltip or not tooltip.AddLine then return end
    tooltip:AddLine("StatPanel")

    -- Item level may be a protected "secret value" in 12.0, which can't be put
    -- into a tooltip line we assemble ourselves. Skip it rather than error.
    local isSecret = SP.IsSecret
    local _, equipped = GetAverageItemLevel()
    if not isSecret(equipped) then
        tooltip:AddDoubleLine("Item level", string.format("%.1f", equipped or 0), 0.8, 0.8, 0.8, 1, 1, 1)
    end

    local fps = GetFramerate() or 0
    if not isSecret(fps) then
        tooltip:AddDoubleLine("FPS", string.format("%.0f", fps), 0.8, 0.8, 0.8, 1, 1, 1)
    end

    local _, specName = SP:GetCurrentPriority()
    if specName then
        tooltip:AddDoubleLine("Spec", specName, 0.8, 0.8, 0.8, 1, 1, 1)
    end
    tooltip:AddDoubleLine("Profile", SP.Config:CurrentProfile(), 0.8, 0.8, 0.8, 1, 1, 1)

    tooltip:AddLine(" ")
    tooltip:AddLine("|cffffff00Left-click|r  open options", 0.6, 0.6, 0.6)
    tooltip:AddLine("|cffffff00Right-click|r  quick menu", 0.6, 0.6, 0.6)
end

--------------------------------------------------------------------------------
-- LDB DATA OBJECT
--------------------------------------------------------------------------------
local dataObject

local function createDataObject()
    if not LDB then return nil end

    return LDB:NewDataObject(addonName, {
        type = "data source",
        text = "StatPanel",
        icon = ICON,
        OnClick = function(self, button) onClick(self, button) end,
        OnTooltipShow = onTooltip,
    })
end

--------------------------------------------------------------------------------
-- CUSTOM MINIMAP BUTTON
--------------------------------------------------------------------------------
local button

-- Places the button on the minimap ring at a saved angle (degrees).
local function reposition(angle)
    local rad = math.rad(angle or 225)
    local radius = (Minimap:GetWidth() / 2) + 6
    button:ClearAllPoints()
    button:SetPoint("CENTER", Minimap, "CENTER",
        math.cos(rad) * radius, math.sin(rad) * radius)
end

local function createMinimapButton()
    button = CreateFrame("Button", "SPAddonMinimapButton", Minimap)
    button:SetSize(31, 31)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel(8)
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:RegisterForDrag("LeftButton")

    -- Round icon cropped to a circle, matching the look of every other
    -- minimap button.
    local icon = button:CreateTexture(nil, "BACKGROUND")
    icon:SetTexture(ICON)
    icon:SetSize(19, 19)
    icon:SetPoint("CENTER", 0, 1)
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    local border = button:CreateTexture(nil, "OVERLAY")
    border:SetTexture([[Interface\Minimap\MiniMap-TrackingBorder]])
    border:SetSize(53, 53)
    border:SetPoint("TOPLEFT")

    button:SetHighlightTexture([[Interface\Minimap\UI-Minimap-ZoomButton-Highlight]])

    button:SetScript("OnClick", function(self, clickButton) onClick(self, clickButton) end)

    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        onTooltip(GameTooltip)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function() GameTooltip:Hide() end)

    -- Drag: follow the cursor around the ring, saving the angle as we go.
    button:SetScript("OnDragStart", function(self)
        self.dragging = true
        self:SetScript("OnUpdate", function()
            local mx, my = Minimap:GetCenter()
            local cx, cy = GetCursorPosition()
            local scale = Minimap:GetEffectiveScale()
            cx, cy = cx / scale, cy / scale
            local angle = math.deg(math.atan2(cy - my, cx - mx))
            SPAddonDB.global.minimap.angle = angle
            reposition(angle)
        end)
    end)
    button:SetScript("OnDragStop", function(self)
        self.dragging = false
        self:SetScript("OnUpdate", nil)
    end)

    reposition(SPAddonDB.global.minimap.angle)
end

--------------------------------------------------------------------------------
-- INIT / VISIBILITY
--------------------------------------------------------------------------------
function Broker:Init()
    -- Make sure the account-wide store exists (Config:Init seeds `global`).
    local g = SPAddonDB.global
    g.minimap = g.minimap or {}
    if g.minimap.angle == nil then g.minimap.angle = 225 end
    if g.minimap.hide == nil then g.minimap.hide = false end

    dataObject = createDataObject()

    -- Prefer LibDBIcon when it's around; otherwise stand up our own button.
    if LDB and LDBIcon and dataObject then
        LDBIcon:Register(addonName, dataObject, g.minimap)
    else
        createMinimapButton()
    end

    self:ApplyVisibility()
    self:StartTicker()
end

-- Honors the "hide minimap button" setting for whichever backend is in use.
function Broker:ApplyVisibility()
    local hidden = SPAddonDB.global.minimap.hide

    if LDBIcon and LDBIcon:IsRegistered(addonName) then
        if hidden then LDBIcon:Hide(addonName) else LDBIcon:Show(addonName) end
    elseif button then
        button:SetShown(not hidden)
    end
end

function Broker:SetHidden(hidden)
    SPAddonDB.global.minimap.hide = hidden and true or false
    self:ApplyVisibility()
end

-- Refreshes the broker text once a second. Cheap, and only matters when a
-- display addon is actually showing it.
function Broker:StartTicker()
    if not dataObject then return end

    local ticker = CreateFrame("Frame")
    local elapsed = 0
    ticker:SetScript("OnUpdate", function(_, dt)
        elapsed = elapsed + dt
        if elapsed < 1 then return end
        elapsed = 0

        local _, equipped = GetAverageItemLevel()
        local fps = GetFramerate() or 0

        -- Display addons concatenate .text themselves, so never hand them a
        -- secret; fall back to the parts we can read.
        if SP.IsSecret(equipped) then
            dataObject.text = SP.IsSecret(fps) and "StatPanel"
                or string.format("%.0f fps", fps)
        else
            dataObject.text = string.format("%.0f fps  |  iLvl %.0f", fps, equipped or 0)
        end
    end)
end
