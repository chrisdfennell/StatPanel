# Translations

StatPanel routes every user-facing string through `SP.L`, so the addon can be
translated without touching the code. The **English string is the key** — there
is no separate English value file to maintain, and any string a translation
doesn't cover falls back to English automatically.

Six languages ship today, all complete against the current key set: German
(`deDE`), Spanish (`esES`), Latin American Spanish (`esMX`), French (`frFR`),
Italian (`itIT`) and Brazilian Portuguese (`ptBR`). Copy any of their shapes.

**None of them has been reviewed by a native speaker.** Terminology follows each
client's own wording where it exists, but if you play in one of these languages
and something reads badly, a corrected line in an issue or PR is genuinely the
most useful contribution you can make.

Russian, Korean and both Chinese locales are missing on purpose: the addon
hardcodes `Fonts\FRIZQT__.TTF`, and those clients use locale-specific font
files, so a translation would likely render as empty boxes. That has to be
fixed before those languages are worth adding.

## Adding a language

1. Generate a stub with every key the addon currently uses:

   ```
   pwsh -File tools\locale-lint.ps1 -Export frFR > Locales\frFR.lua
   ```

   Where the locale is the client value returned by `GetLocale()` — `deDE`,
   `frFR`, `ruRU`, `koKR`, `zhCN`, `zhTW`, `esES`, `esMX`, `ptBR`, `itIT`.

   Every line comes out commented, so the stub is valid Lua as it stands.
   Uncomment and translate the lines you finish; the rest keep falling back to
   English. Partial translations are supported on purpose.

2. The file's header must name its own locale:

   ```lua
   local _, SP = ...
   local L = SP.Locale("frFR")

   L["Show panel"] = "Afficher le panneau"
   ```

   `SP.Locale` returns the live table when the file's locale matches the
   client, and a throwaway table otherwise — so every locale file can load on
   every client without guards.

3. Add the file to `StatPanel.toc`, right after `Locale.lua`:

   ```
   Locale.lua
   Locales\frFR.lua
   Media.lua
   ```

4. Add a `## Notes-frFR:` line to `StatPanel.toc` alongside the others. That's
   what the in-game addon list and the CurseForge / Wago pages show. The title
   is a proper noun and stays untranslated.

5. Run the linter before opening a PR:

   ```
   pwsh -File tools\locale-lint.ps1
   ```

## What not to translate

The fallback is forgiving, which makes a handful of things easy to break
quietly. Leave these exactly as they appear in the key:

- **`$tokens`** — `$value`, `$rating`, `$equipped`, `$spec` and friends are
  parsed out of the format string by the panel. Translate the words around
  them, not the tokens.
- **Format specifiers** — `%s`, `%d`, `%.2f`. A translation must consume the
  same arguments as its key or `:format()` errors. To reorder them, use Lua's
  positional form: `%1$s`, `%2$d`.
- **Color codes** — `|cffffd100 … |r` must survive intact.
- **Slash subcommands** — `/sp toggle`, `/sp preset`. These are typed, not read.
  The `<name>` placeholder after them is prose and can be translated.
- **Media names** — "Flat", "Pixel", "Friz Quadrata" and the other texture,
  border and font names are absent from the key list on purpose. They are
  lookup keys and LibSharedMedia registration names that get written into saved
  profiles, so translating them would make a profile written on one client
  unreadable on another.

## Strings you don't have to translate at all

Stat names and gear slot names go through `SP.Global`, which prefers Blizzard's
own `GlobalStrings` — `STAT_HASTE`, `HEADSLOT` and so on — and only falls back
to `SP.L` if the global is missing. Those already read correctly in all twelve
client locales with no work from you. The English text is still passed as the
fallback key, so you *may* override it, and `deDE.lua` does, but it only ever
shows if a future patch removes the global.

The exceptions are the deliberately abbreviated forms — `Crit`, `Mast`, `Vers` —
which label the compact priority chain where the full Blizzard names wouldn't
fit. Those are ours and do need translating.

## What the linter checks

`SP.L` is designed to never fail: an untranslated key renders English, and a key
with no entry renders itself. That's right at runtime, but it also means the two
mistakes translators actually make are completely silent. `tools/locale-lint.ps1`
catches them, and CI runs it on every pull request:

| Check | Why it matters |
| --- | --- |
| Orphaned key | A typo'd key just renders the English forever. Nothing looks wrong. |
| Format specifier mismatch | A dropped or retyped `%s` makes `:format()` error at the call site, far from the locale file. |
| Duplicate key | The later entry silently wins. |
| Empty translation | Renders as blank instead of falling back. Delete the line instead. |
| Wrong `SP.Locale` argument | Writes onto the wrong table, or onto `SP.L` for every client. |
| Not listed in the TOC | The file never loads at all. |

It also reports coverage per locale. Untranslated keys are counted, not treated
as errors.
