-- Locale.lua (Translation table + registration)
--
-- A tiny locale system, hand-rolled rather than AceLocale, because StatPanel
-- embeds no libraries. Every user-facing string is looked up in SP.L; the
-- English base always loads, and a matching non-English client locale overlays
-- it, so an untranslated key falls back to English and a missing key falls back
-- to itself (the key text). Nothing ever comes back nil.
--
-- Load order matters: this file and the Locales/ tables come first in the .toc,
-- before anything that reads SP.L.

local addonName, SP = ...

-- __index returns the key itself, so a string with no entry at all still shows
-- readable text instead of nil -- the last-resort safety net beneath the
-- English base.
SP.L = setmetatable({}, {
    __index = function(_, key) return key end,
})

-- Each Locales/xxYY.lua calls this and assigns its strings onto the result:
--   local L = SP.Locale("deDE"); L["Show panel"] = "Panel anzeigen"
-- enUS is the base and always applies. A file whose locale matches the client
-- overlays it. Any other locale's assignments land on a throwaway table and are
-- discarded, so every translation file can load unconditionally.
function SP.Locale(locale)
    if locale == "enUS" or locale == GetLocale() then
        return SP.L
    end
    return {}
end
