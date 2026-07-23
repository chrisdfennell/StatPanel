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
local GetGemQuality  = C_Item and C_Item.GetItemQualityByID
local GetSetBonuses  = C_Item and C_Item.GetSetBonusesForSpecializationByItemID
local GetTooltipData = C_TooltipInfo and C_TooltipInfo.GetInventoryItem
local isSecret       = SP.IsSecret or function() return false end

-- Slots that hold a class tier piece, and the count that makes a full set. The
-- set count has no single API: we ask each of these slots whether its item
-- grants a set bonus for the current spec and tally the answers.
local TIER_SLOTS = { 1, 3, 5, 10, 7 }  -- Head, Shoulder, Chest, Hands, Legs
local TIER_TOTAL = #TIER_SLOTS

-- Upgrade tracks in ascending order, current-season naming. Only used to
-- recognise the track word in the tooltip line; membership here is what tells a
-- real "Champion 6/8" line apart from any other "word N/M" text.
local UPGRADE_TRACKS = {
    Explorer = true, Adventurer = true, Veteran = true,
    Champion = true, Hero = true, Myth = true,
}

-- An item link carries its enchant and gems inline:
--   item:itemID:enchantID:gem1:gem2:gem3:gem4:...
local function parseLink(link)
    if type(link) ~= "string" then return nil end

    local payload = link:match("|Hitem:([%-%d:]+)|h")
    if not payload then return nil end

    -- Split on the colon with strsplit rather than gmatch. In WoW's Lua 5.1
    -- `gmatch("([^:]*)")` yields a spurious empty capture after every delimiter,
    -- so the fields come out shifted by one and the enchant (field 2) always
    -- reads back as the empty string, i.e. 0 -- every enchanted item looked
    -- unenchanted. strsplit keeps empty fields in place without the phantom
    -- captures, so the positions line up with the link layout above.
    local raw = { strsplit(":", payload) }
    local fields = {}
    for i = 1, #raw do fields[i] = tonumber(raw[i]) or 0 end

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

-- Counts gems below Epic quality in a parsed gem list. A rare gem in an epic
-- item is a small, easily-forgotten upgrade -- the socketed equivalent of
-- leaving on a lower-rank enchant.
local function countLowGems(gems)
    if not GetGemQuality or type(gems) ~= "table" then return 0 end
    local low = 0
    for _, gemID in ipairs(gems) do
        if gemID and gemID > 0 then
            local ok, quality = pcall(GetGemQuality, gemID)
            -- Enum.ItemQuality: 4 = Epic. Below that is a downgrade worth noting.
            if ok and type(quality) == "number" and quality < 4 then
                low = low + 1
            end
        end
    end
    return low
end

-- Equipped tier pieces (0..TIER_TOTAL), or nil if the API or spec is
-- unavailable. There is no "N of 5" API; we ask each tier slot's item whether it
-- grants a set bonus for the current spec and count the ones that do -- which is
-- also how Catalyst-made pieces get counted, since they carry the real bonus.
local function countTierPieces()
    if not GetSetBonuses then return nil end
    local index = GetSpecialization and GetSpecialization()
    local specID = index and GetSpecializationInfo(index)
    if not specID then return nil end

    local count = 0
    for _, slotID in ipairs(TIER_SLOTS) do
        local itemID = GetInventoryItemID("player", slotID)
        if itemID then
            local ok, spells = pcall(GetSetBonuses, specID, itemID)
            if ok and type(spells) == "table" and #spells > 0 then
                count = count + 1
            end
        end
    end
    return count
end

-- Reads an equipped item's upgrade track and progress by scanning its tooltip,
-- because no API returns it for an arbitrary equipped item. Returns track name,
-- current and max upgrade level (e.g. "Champion", 6, 8), or nil.
--
-- This is best-effort: the track word is localized, so on a non-English client
-- it simply finds nothing and the audit omits upgrade info rather than guessing.
-- Every step is guarded -- a tooltip read must never take the audit down.
local function scanUpgrade(slotID)
    if not GetTooltipData then return nil end

    local ok, data = pcall(GetTooltipData, "player", slotID)
    if not ok or type(data) ~= "table" or type(data.lines) ~= "table" then return nil end
    if TooltipUtil and TooltipUtil.SurfaceArgs then pcall(TooltipUtil.SurfaceArgs, data) end

    for _, line in ipairs(data.lines) do
        if TooltipUtil and TooltipUtil.SurfaceArgs then pcall(TooltipUtil.SurfaceArgs, line) end
        local text = line.leftText
        -- Item tooltip lines are not secret values in 12.0, but guard anyway:
        -- a secret string can't be pattern-matched.
        if type(text) == "string" and not isSecret(text) then
            local track, cur, max = text:match("(%a+)%s+(%d+)/(%d+)")
            if track and UPGRADE_TRACKS[track] then
                return track, tonumber(cur), tonumber(max)
            end
        end
    end
    return nil
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
        lowGems = 0,
        notMaxUpgrade = 0,
        tierCount = countTierPieces(),  -- nil when unavailable
        tierTotal = TIER_TOTAL,
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
            entry.lowGems = parsed and countLowGems(parsed.gems) or 0

            entry.upgradeTrack, entry.upgradeCur, entry.upgradeMax = scanUpgrade(slot.id)
            if entry.upgradeCur and entry.upgradeMax and entry.upgradeCur < entry.upgradeMax then
                result.notMaxUpgrade = result.notMaxUpgrade + 1
            end

            if entry.needsEnchant then result.missingEnchants = result.missingEnchants + 1 end
            result.emptySockets = result.emptySockets + entry.emptySockets
            result.lowGems = result.lowGems + entry.lowGems

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
            if slot.lowGems > 0 then
                notes[#notes + 1] = colorize(slot.lowGems .. " rare gem", 0.95, 0.6, 0.25)
            end

            -- The upgrade track sits after the item level, dimmed when maxed and
            -- highlighted when there is headroom left.
            local track = ""
            if slot.upgradeTrack and slot.upgradeCur and slot.upgradeMax then
                local maxed = slot.upgradeCur >= slot.upgradeMax
                track = "  " .. colorize(
                    string.format("%s %d/%d", slot.upgradeTrack, slot.upgradeCur, slot.upgradeMax),
                    maxed and 0.5 or 0.55, maxed and 0.5 or 0.7, maxed and 0.55 or 0.95)
            end

            local marker = ""
            if audit.lowest and slot.id == audit.lowest.id then
                marker = colorize("  <- lowest", 0.6, 0.6, 0.65)
            end

            print(string.format("  %-12s %d%s%s%s", slot.name, slot.itemLevel, track,
                #notes > 0 and ("  " .. table.concat(notes, ", ")) or "", marker))
        end
    end

    local overall, equipped = GetAverageItemLevel()
    equipped = SP.PlainNumber(equipped)
    if equipped then
        print(string.format("  %-12s %.2f", "Equipped", equipped))
    end

    if audit.tierCount then
        local full = audit.tierCount >= audit.tierTotal
        print("  " .. colorize(string.format("Tier set    %d/%d", audit.tierCount, audit.tierTotal),
            full and 0.35 or 0.6, full and 0.85 or 0.6, full and 0.4 or 0.65))
    end
    if audit.notMaxUpgrade > 0 then
        print("  " .. colorize(audit.notMaxUpgrade .. " item"
            .. (audit.notMaxUpgrade == 1 and "" or "s") .. " not fully upgraded", 0.6, 0.6, 0.65))
    end

    if audit.missingEnchants == 0 and audit.emptySockets == 0 and audit.emptySlots == 0
        and audit.lowGems == 0 then
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
    if audit.lowGems > 0 then
        issues[#issues + 1] = audit.lowGems .. " rare gem" .. (audit.lowGems == 1 and "" or "s")
    end
    if audit.emptySlots > 0 then
        issues[#issues + 1] = audit.emptySlots .. " empty slot" .. (audit.emptySlots == 1 and "" or "s")
    end

    if #issues == 0 then return nil end
    return "Missing: " .. table.concat(issues, ", ")
end
