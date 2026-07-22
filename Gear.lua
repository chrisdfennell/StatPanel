-- Gear.lua (Equipped item audit: item level, enchants, sockets)
--
-- Item data is NOT covered by the secret-value system, so unlike the combat
-- stats everything here can be read, compared and reported normally.
--
-- The audit answers the three questions worth asking before a raid: what is my
-- real item level per slot, which slot is dragging me down, and have I forgotten
-- an enchant or left a socket empty.

local addonName, SP = ...

local Gear = {}
SP.Gear = Gear

-- Slot list in the order the character sheet shows them. Shirt (4) and tabard
-- (19) are cosmetic and deliberately excluded.
local SLOTS = {
    { id = 1,  name = "Head" },
    { id = 2,  name = "Neck" },
    { id = 3,  name = "Shoulder" },
    { id = 15, name = "Back" },
    { id = 5,  name = "Chest" },
    { id = 9,  name = "Wrist" },
    { id = 10, name = "Hands" },
    { id = 6,  name = "Waist" },
    { id = 7,  name = "Legs" },
    { id = 8,  name = "Feet" },
    { id = 11, name = "Ring 1" },
    { id = 12, name = "Ring 2" },
    { id = 13, name = "Trinket 1" },
    { id = 14, name = "Trinket 2" },
    { id = 16, name = "Main Hand" },
    { id = 17, name = "Off Hand" },
}

-- Slots that normally take an enchant at max level. This shifts between
-- expansions - edit freely if a patch changes what's enchantable.
local ENCHANTABLE = {
    [15] = true,  -- Back
    [5]  = true,  -- Chest
    [9]  = true,  -- Wrist
    [7]  = true,  -- Legs
    [8]  = true,  -- Feet
    [11] = true,  -- Ring 1
    [12] = true,  -- Ring 2
    [16] = true,  -- Main Hand
}

--------------------------------------------------------------------------------
-- API SHIMS
--------------------------------------------------------------------------------
local GetItemLevel = (C_Item and C_Item.GetDetailedItemLevelInfo) or _G.GetDetailedItemLevelInfo
local GetStats     = (C_Item and C_Item.GetItemStats) or _G.GetItemStats

-- An item link carries its enchant and gems inline:
--   item:itemID:enchantID:gem1:gem2:gem3:gem4:...
local function parseLink(link)
    if type(link) ~= "string" then return nil end

    local payload = link:match("|Hitem:([%-%d:]+)|h")
    if not payload then return nil end

    local fields = {}
    for value in payload:gmatch("([^:]*)") do
        fields[#fields + 1] = tonumber(value) or 0
    end

    return {
        itemID   = fields[1] or 0,
        enchant  = fields[2] or 0,
        gems     = { fields[3] or 0, fields[4] or 0, fields[5] or 0, fields[6] or 0 },
    }
end

-- Counts sockets that are present but unfilled. GetItemStats reports empty
-- sockets as EMPTY_SOCKET_* keys; filled ones appear as gem IDs in the link.
local function countEmptySockets(link)
    if not GetStats then return 0 end

    local ok, stats = pcall(GetStats, link)
    if not ok or type(stats) ~= "table" then return 0 end

    local empty = 0
    for key, count in pairs(stats) do
        if type(key) == "string" and key:find("EMPTY_SOCKET") then
            empty = empty + (tonumber(count) or 0)
        end
    end
    return empty
end

--------------------------------------------------------------------------------
-- AUDIT
--------------------------------------------------------------------------------
-- Returns a table describing every equipped slot plus totals. Safe to call as
-- often as you like; it reads live data each time.
function Gear:Audit()
    local result = {
        slots = {},
        missingEnchants = 0,
        emptySockets = 0,
        emptySlots = 0,
        lowest = nil,
        highest = nil,
        average = 0,
    }

    local total, counted = 0, 0

    for _, slot in ipairs(SLOTS) do
        local link = GetInventoryItemLink("player", slot.id)
        local entry = { id = slot.id, name = slot.name, link = link }

        if link then
            local level = GetItemLevel and select(1, GetItemLevel(link)) or nil
            entry.itemLevel = tonumber(level) or 0

            local parsed = parseLink(link)
            entry.enchanted = parsed and parsed.enchant ~= 0 or false
            entry.needsEnchant = ENCHANTABLE[slot.id] and not entry.enchanted or false
            entry.emptySockets = countEmptySockets(link)

            if entry.needsEnchant then result.missingEnchants = result.missingEnchants + 1 end
            result.emptySockets = result.emptySockets + entry.emptySockets

            if entry.itemLevel > 0 then
                total = total + entry.itemLevel
                counted = counted + 1
                if not result.lowest or entry.itemLevel < result.lowest.itemLevel then
                    result.lowest = entry
                end
                if not result.highest or entry.itemLevel > result.highest.itemLevel then
                    result.highest = entry
                end
            end
        else
            -- Off hand is legitimately empty for plenty of specs, so it is not
            -- counted as a problem.
            entry.empty = true
            if slot.id ~= 17 then result.emptySlots = result.emptySlots + 1 end
        end

        result.slots[#result.slots + 1] = entry
    end

    result.average = counted > 0 and (total / counted) or 0
    return result
end

--------------------------------------------------------------------------------
-- REPORT
--------------------------------------------------------------------------------
local function colorize(text, r, g, b)
    return string.format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, text)
end

function Gear:PrintReport()
    local audit = self:Audit()

    SP:Print("gear audit")

    for _, slot in ipairs(audit.slots) do
        if slot.empty then
            if slot.id ~= 17 then
                print(string.format("  %-12s %s", slot.name, colorize("empty", 0.9, 0.3, 0.3)))
            end
        else
            local notes = {}
            if slot.needsEnchant then notes[#notes + 1] = colorize("no enchant", 0.95, 0.6, 0.25) end
            if slot.emptySockets > 0 then
                notes[#notes + 1] = colorize(slot.emptySockets .. " empty socket", 0.95, 0.6, 0.25)
            end

            local marker = ""
            if audit.lowest and slot.id == audit.lowest.id then
                marker = colorize("  <- lowest", 0.6, 0.6, 0.65)
            end

            print(string.format("  %-12s %d%s%s", slot.name, slot.itemLevel,
                #notes > 0 and ("  " .. table.concat(notes, ", ")) or "", marker))
        end
    end

    local overall, equipped = GetAverageItemLevel()
    equipped = SP.PlainNumber(equipped)
    if equipped then
        print(string.format("  %-12s %.2f", "Equipped", equipped))
    end

    if audit.missingEnchants == 0 and audit.emptySockets == 0 and audit.emptySlots == 0 then
        print("  " .. colorize("Everything is enchanted and socketed.", 0.35, 0.85, 0.4))
    end
end

--------------------------------------------------------------------------------
-- SUMMARY FOR THE PANEL / TOOLTIP
--------------------------------------------------------------------------------
-- Short one-line summary, or nil when there is nothing to warn about.
function Gear:WarningText()
    local audit = self:Audit()
    local issues = {}

    if audit.missingEnchants > 0 then
        issues[#issues + 1] = audit.missingEnchants .. " enchant" .. (audit.missingEnchants == 1 and "" or "s")
    end
    if audit.emptySockets > 0 then
        issues[#issues + 1] = audit.emptySockets .. " socket" .. (audit.emptySockets == 1 and "" or "s")
    end
    if audit.emptySlots > 0 then
        issues[#issues + 1] = audit.emptySlots .. " empty slot" .. (audit.emptySlots == 1 and "" or "s")
    end

    if #issues == 0 then return nil end
    return "Missing: " .. table.concat(issues, ", ")
end
