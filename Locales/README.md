# Translations

StatPanel routes every user-facing string through `SP.L`, so the addon can be
translated without touching the code. The **English string is the key** — there
is no separate English value file to maintain, and any string a translation
doesn't cover falls back to English automatically.

## Adding a language

1. Create `Locales/<locale>.lua`, where `<locale>` is the client value returned
   by `GetLocale()` — `deDE`, `frFR`, `ruRU`, `koKR`, `zhCN`, `zhTW`, `esES`,
   `esMX`, `ptBR`, `itIT`.

2. Start it like this and translate the right-hand side only:

   ```lua
   local _, SP = ...
   local L = SP.Locale("deDE")

   L["Show panel"] = "Panel anzeigen"
   L["Lock position"] = "Position sperren"
   -- ...only the strings you translate; the rest stay English.
   ```

   `SP.Locale` returns the live table when the file's locale matches the
   client, and a throwaway table otherwise — so every locale file can load on
   every client without guards.

3. Add the file to `StatPanel.toc`, right after `Locale.lua`:

   ```
   Locale.lua
   Locales\deDE.lua
   Media.lua
   ```

The keys are the exact English strings as they appear in the UI. You do not need
to translate all of them at once — partial translations are fine and fall back
to English key by key.
