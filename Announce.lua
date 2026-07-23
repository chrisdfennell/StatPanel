-- Announce.lua (Report your gear and stats to a chat channel)
--
-- Every field is assembled defensively. Patch 12.0 makes most combat stats
-- "secret values", and chat is not one of the APIs allowed to receive them -
-- passing one to SendChatMessage would either error or leak protected data,
-- which is precisely what that system exists to prevent.
--
-- So rather than assume which stats are readable, each one is probed with
-- SP.PlainNumber and included only if it comes back as a real number. Today
-- that means item level, spec and speed get through while the secondary stats
-- don't. If a future patch changes what is secret, this starts including them
-- with no code change.
--
-- Announcing is always user-initiated and throttled: nothing here fires by
-- itself, because nobody wants an addon spamming their raid chat.

local addonName, SP = ...

local Announce = {}
SP.Announce = Announce

local THROTTLE_SECONDS = 8
local lastSent = 0
local warnedAboutSecrets = false

-- "SELF" isn't a real chat type; it prints locally so you can preview.
Announce.channels = {
    { name = "Print to my chat only", value = "SELF" },
    { name = "Say",      value = "SAY" },
    { name = "Party",    value = "PARTY" },
    { name = "Raid",     value = "RAID" },
    { name = "Instance", value = "INSTANCE_CHAT" },
    { name = "Guild",    value = "GUILD" },
    { name = "Officer",  value = "OFFICER" },
    { name = "Yell",     value = "YELL" },
    { name = "Whisper",  value = "WHISPER" },
}

--------------------------------------------------------------------------------
-- MESSAGE ASSEMBLY
--------------------------------------------------------------------------------
-- Returns the message plus a count of fields that had to be dropped because
-- the game protects them.
function Announce:Build()
    local cfg = SP.db.announce
    local plain = SP.PlainNumber
    local parts, dropped = {}, 0

    -- Item level. Equipped and overall differ when you're carrying upgrades.
    if cfg.includeItemLevel then
        local overall, equipped = GetAverageItemLevel()
        overall, equipped = plain(overall), plain(equipped)
        if equipped then
            if overall and math.abs(overall - equipped) >= 0.05 then
                parts[#parts + 1] = string.format("iLvl %.2f (%.2f overall)", equipped, overall)
            else
                parts[#parts + 1] = string.format("iLvl %.2f", equipped)
            end
        else
            dropped = dropped + 1
        end
    end

    if cfg.includeSpec then
        local _, specName = SP:GetCurrentPriority()
        local className = UnitClass("player")
        if specName and className then
            parts[#parts + 1] = specName .. " " .. className
        elseif className then
            parts[#parts + 1] = className
        end
    end

    -- Stats: probe each one; secret values simply don't make the cut.
    if cfg.includeStats then
        local statParts = {}
        for _, statName in ipairs(SP.STAT_ORDER) do
            local statCfg = SP.db.stats[statName]
            local def = SP.STAT_DEFS[statName]
            if statCfg and statCfg.enabled and def then
                local value = plain((def.get(SP.db.valueSource)))
                if value then
                    local decimals = math.max(0, math.min(2, statCfg.decimals or 0))
                    statParts[#statParts + 1] = string.format(
                        "%s %." .. decimals .. "f%%", statCfg.label or def.name, value)
                else
                    dropped = dropped + 1
                end
            end
        end
        if #statParts > 0 then
            parts[#parts + 1] = table.concat(statParts, ", ")
        end
    end

    if cfg.includePriority then
        local priority = SP:GetCurrentPriority()
        parts[#parts + 1] = "priority " .. table.concat(priority, " > ")
    end

    if cfg.includeSpeed then
        local peak = plain(SP.GetPeakSpeed and SP.GetPeakSpeed())
        if peak and peak > 0 then
            parts[#parts + 1] = string.format("peak speed %.0f%%", peak)
        end
    end

    if cfg.includeGear and SP.Gear then
        local audit = SP.Gear:Audit()
        if audit then
            local issues = {}
            if audit.missingEnchants > 0 then
                issues[#issues + 1] = audit.missingEnchants .. " missing enchant"
                    .. (audit.missingEnchants == 1 and "" or "s")
            end
            if audit.emptySockets > 0 then
                issues[#issues + 1] = audit.emptySockets .. " empty socket"
                    .. (audit.emptySockets == 1 and "" or "s")
            end
            if audit.tierCount then
                parts[#parts + 1] = string.format("%d/%d tier set", audit.tierCount, audit.tierTotal)
            end
            if #issues > 0 then
                parts[#parts + 1] = table.concat(issues, ", ")
            end
        end
    end

    local prefix = cfg.prefix or ""
    local body = table.concat(parts, " | ")
    if body == "" then return nil, dropped end

    return (prefix ~= "" and (prefix .. " ") or "") .. body, dropped
end

--------------------------------------------------------------------------------
-- SENDING
--------------------------------------------------------------------------------
local function channelAvailable(channel)
    if channel == "PARTY" or channel == "INSTANCE_CHAT" then
        return IsInGroup(), "You aren't in a group."
    elseif channel == "RAID" then
        return IsInRaid(), "You aren't in a raid."
    elseif channel == "GUILD" or channel == "OFFICER" then
        return IsInGuild(), "You aren't in a guild."
    end
    return true
end

function Announce:Send(channel, target)
    channel = channel or SP.db.announce.channel or "SELF"

    local now = GetTime()
    if channel ~= "SELF" and (now - lastSent) < THROTTLE_SECONDS then
        SP:Print(string.format("hold on - you can announce again in %.0f seconds.",
            THROTTLE_SECONDS - (now - lastSent)))
        return false
    end

    local message, dropped = self:Build()
    if not message then
        SP:Print("nothing to announce - enable some fields on the Announce page.")
        return false
    end

    -- Explain the omission once per session rather than on every announce.
    if dropped > 0 and not warnedAboutSecrets then
        warnedAboutSecrets = true
        SP:Print(("%d value%s left out: the game protects those stats, so they cannot be sent to chat.")
            :format(dropped, dropped == 1 and " was" or "s were"))
    end

    if channel == "SELF" then
        SP:Print(message)
        return true
    end

    local ok, err = channelAvailable(channel)
    if not ok then
        SP:Print(err .. " Showing it here instead:")
        SP:Print(message)
        return false
    end

    if channel == "WHISPER" then
        target = target and target:trim() or ""
        if target == "" then
            SP:Print("whisper needs a name: /sp announce whisper <name>")
            return false
        end
    end

    -- A secret slipping this far would error inside SendChatMessage, so the
    -- call is guarded and falls back to a local print.
    local sent = pcall(SendChatMessage, message, channel, nil, target)
    if not sent then
        SP:Print("the game refused to send that message. Showing it here instead:")
        SP:Print(message)
        return false
    end

    lastSent = now
    return true
end
