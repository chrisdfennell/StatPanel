# Changelog

All notable changes to StatPanel are recorded here.

This project follows [Semantic Versioning](https://semver.org/) and the format
of [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Changed

- **Interface version bumped to `120100` for patch 12.1.0.** No code changes
  were needed; this is the flag that stops the client and the listing sites
  marking the addon out of date.

## [2.5.0] - 2026-08-06

### Fixed

- **Removing a stat from a section did not stick.** The profile sanitizer
  treated a section's stat list as a fixed-length array -- the rule that exists
  to repair a garbled `{r,g,b,a}` colour -- so any section the user had
  shortened was "repaired" back to the default membership on the next
  `Config:Activate`, which is every login. There was no error and nothing on
  screen to explain it; the stat you removed was simply back. Colour arrays are
  now identified by holding numbers, and a variable-length list of names keeps
  the length the user gave it. Found by the new test suite.

### Added

- **Four more translations**, all complete against the 520-key string set:
  Russian (`ruRU`), Korean (`koKR`), Simplified Chinese (`zhCN`) and
  Traditional Chinese (`zhTW`). These were blocked in 2.4.0 and the reason is
  now gone -- see *Locale-correct fonts* below.

  `zhTW` is written out rather than converted from `zhCN`. The two clients
  differ in more than script: Versatility is 臨機應變 against 全能, Crit is
  爆擊 against 暴擊, Leech is 汲取 against 吸血. A character-level conversion
  would have produced text that reads fine and is wrong in precisely the words
  a user is looking for.

  **None of the ten translations has been reviewed by a native speaker.**
  Terminology follows each client's own wording where it exists, and every file
  says so in its header and points at the issue tracker.

- **Locale-correct fonts.** The addon named `Fonts\FRIZQT__.TTF` directly in
  eleven places. That file exists on the Korean and Chinese clients but carries
  Latin glyphs only, so it loads, reports success, and draws empty boxes --
  there is no error to catch. `Media:UIFont()` now resolves the client's own
  font (`STANDARD_TEXT_FONT`, falling back to whatever `GameFontNormal` uses),
  and a new **Game Default** font choice means the same in the options. A
  preset or profile naming a Latin-only face on a non-Latin client is
  substituted at draw time rather than rendering as boxes, and the font
  dropdown says which faces this applies to.

- **A test suite.** `tests/` loads the addon under a stubbed WoW client and
  exercises the pure logic directly: Pawn/sim priority parsing, the `$token`
  value templates and their secret-value guarantees, the profile schema, the v1
  migration, sanitizing a corrupt profile, the import/export round trip, and
  every preset. 160 tests, no dependencies -- `tests/harness.lua` is the
  framework and CI already installs Lua. Run with `lua tests/run.lua`.

  The preset check is the one worth calling out: a preset key that no longer
  matches the defaults schema is written into the profile, read by nobody, and
  silently does less than it claims. All 22 are now checked against the schema
  on every push.

- **Key bindings** for showing the panel, locking it, opening the options,
  cycling to the next profile, and running the gear audit. In the game's Key
  Bindings window under *StatPanel*; none is bound by default.

- **`/sp debug`** collects the addon version, game build, locale, class, spec,
  whether the client is protecting combat stats, the active profile, panel
  state, the requested *and actually drawn* font, and which optional libraries
  are present -- into one selectable box to paste into a bug report. It carries
  no character or realm name; the usual destination is a public issue tracker.

- **Five new stats**, all off by default: attack power (ranged for hunters),
  spell power, maximum health, maximum mana, and Brewmaster stagger.

- **`$per`**, a new value-format token: the combat rating cost of one percent
  of a stat. `$value% ($per)` renders as `18.25% (120)`. It divides by the
  rating *bonus* rather than the displayed value, so a stat with a base the
  rating never paid for (crit) is not understated, and the answer does not
  change with the total/bonus setting.

- **Gear durability and repair cost in the footer** -- the lowest durability
  across equipped slots, so you see the broken piece rather than an average,
  with its own good/poor colour thresholds. The repair cost only appears at a
  merchant, because that is the only place the game will price one.

- **Precise panel position.** Anchor point, screen anchor and X/Y are now
  editable in the options rather than only draggable, for lining the panel up
  with another addon or putting it back where it was.

- **A Colorblind Safe preset.** The default palette puts Crit in red and
  Mastery in green, the two hues red-green colour blindness cannot separate,
  and every other preset inherits it. This one uses the Okabe-Ito qualitative
  palette and does not rely on colour alone: rank numbers are on, and the
  footer's good/fair/poor scale is blue/yellow/vermillion.

- **A "what's new" notice**, printed to chat once per version rather than shown
  as a popup. Silent on a fresh install.

- **The priority box accepts more of what people type**: the abbreviations the
  panel itself displays (`Mast`, `Vers`), and the client's own stat names, so a
  German user can type *Tempo*. Its tokenizer no longer depends on ASCII
  letters, which previously meant a Cyrillic or Korean stat order parsed as
  zero words.

- `.github/dependabot.yml` for the pinned CI actions, monthly.

- `docs/MULTI-PANEL.md` -- a measured design note on a second panel: why it is
  a schema migration and 111 option bindings rather than a small feature, and a
  four-stage plan for doing it safely. Not implemented.

## [2.4.0] - 2026-07-27

### Added

- **Five more translations**, each complete against the current 452-key string
  set: French (`frFR`), Spanish (`esES`), Latin American Spanish (`esMX`),
  Brazilian Portuguese (`ptBR`) and Italian (`itIT`). Every one carries a
  `## Notes-<locale>` line for the in-game addon list and the store pages.

  `esMX.lua` is derived from `esES.lua` rather than hand-copied. The two
  Blizzard localizations differ in scattered vocabulary, not in structure, and
  deriving it means the key set cannot silently drift out of step.

  **None of these have been reviewed by a native speaker.** Terminology follows
  each client's own wording where it exists, and every file says so in its
  header and points at the issue tracker. Corrections are welcome.

### Not included

- Russian, Korean and both Chinese locales are deliberately absent. The addon
  hardcodes `Fonts\FRIZQT__.TTF` in ten places, and Blizzard ships
  locale-specific fonts for those clients, so a translation would likely render
  as empty boxes rather than text. That needs resolving first -- a translation
  nobody can read is worse than English.

## [2.3.0] - 2026-07-27

### Added

- **Localization support.** The addon had none -- every user-facing string was
  an inline English literal, so it could never be translated. There is now a
  tiny locale table (`SP.L`, no embedded library): the English string is the
  key, and a translation file for the client's language overlays it, with any
  untranslated string falling back to English. Every user-facing string -- the
  options window, the panel tooltip and stat names, the slash commands, the
  right-click menu, the gear report and the chat announce -- is routed through
  it. Shipping English-complete and translation-ready; `Locales/README.md`
  documents how to add a language. Identifiers (config keys, value-format
  tokens, preset names) are deliberately left untranslated.

- **Stat and gear-slot names come from the client.** `SP.Global` prefers
  Blizzard's own `GlobalStrings` (`STAT_HASTE`, `HEADSLOT`, ...) and falls back
  to `SP.L` only if a global is missing, so those names are already correct in
  all twelve locales with no translator effort. The deliberately abbreviated
  forms used by the compact priority chain (`Crit`, `Mast`, `Vers`) stay in
  `SP.L` — the Blizzard names are the full ones and wouldn't fit.

- **German translation** (`Locales/deDE.lua`), complete against the current
  string set.

- **Localized addon-list metadata.** `## Notes-<locale>` headers for the ten
  translated client locales, read by the in-game addon list and the CurseForge
  and Wago listings.

- **`tools/locale-lint.ps1`.** `SP.L` never fails at runtime, which means the
  two mistakes translators actually make are silent: a mistyped key renders the
  English forever, and a translation that drops or reorders a format specifier
  only errors at the far-away `:format()` call. The linter reports both, plus
  duplicate keys, empty translations, a locale file whose `SP.Locale` argument
  doesn't match its filename, and one missing from the TOC. `-Export <locale>`
  emits a ready-to-fill stub. CI runs it on every pull request.

### Fixed

- Strings the first localization pass missed: the font-outline dropdown names,
  the live-preview window, and the gear list on the Gear options page, which
  duplicated the chat report's wording as English literals.

- Sentences assembled with `..` now use format strings, so translations can
  reorder them: "Current specialization: %s", "Background: %s", "Priority %d"
  and the announce channel fallback.

- The CI TOC check anchored its pattern on `[A-Za-z0-9_/-]+`, which stops at the
  backslash in a Windows-style TOC path. Every subdirectory entry was skipped
  silently, so a broken `Locales\` path would have passed. Separators are now
  normalized before matching, and the check walks subdirectories too.

## [2.2.0] - 2026-07-23

### Added

- **Deeper gear audit.** `/sp gear`, the Gear options page and the chat announce
  now report more than enchants and sockets:
  - **Tier set count** — how many class set pieces you have equipped, e.g.
    `4/5`. Counted through the current set-bonus API, so Catalyst-made pieces
    count the same as drops.
  - **Upgrade track and progress** per slot — `Champion 6/8`, dimmed once a slot
    is maxed — plus a tally of items not yet fully upgraded. There is no API for
    an equipped item's track, so this is read from the item tooltip: best-effort
    on English clients, and quietly omitted rather than guessed elsewhere.
  - **Below-Epic gems** — a rare gem sitting in an epic item is flagged like a
    missing enchant, since it's an easily-forgotten upgrade.

  Enchant *rank* and embellishment detection were left out on purpose: both need
  a per-season maintained table or fragile tooltip matching, and would quietly
  rot between patches rather than fail loudly.

## [2.1.1] - 2026-07-23

### Fixed

- **The live preview could appear on login with no options window behind it.**
  Registering the options canvas at login fires its `OnShow` once, transiently,
  before the Settings window has ever been opened -- and that started the live
  preview, leaving the panel docked in a preview box on screen until you opened
  and closed the options to trigger a real teardown. The preview now starts only
  when the Settings window is actually open.

## [2.1.0] - 2026-07-22

### Added

- **Paste a stat weight string to set your priority.** Options → Priority has a
  new box that takes a Pawn string -- from Raidbots, a sim, or a stat site -- or
  a plain order like `Mastery > Haste > Crit > Versatility`, and sets the
  priority for your current specialization. It reads the four secondaries,
  orders them by weight (or takes the order as written) and fills in any it
  doesn't see, so the result is always a complete order. The built-in table is a
  general baseline that drifts with the meta and can't know your gear; this is
  the authoritative-for-your-character answer, for any spec, from whatever
  source you trust. It writes the same per-spec override the dropdowns do, so
  "Use the built-in order" still resets it.

## [2.0.3] - 2026-07-22

### Fixed

- **The gear audit reported missing enchants on every slot, even on a fully
  enchanted character.** `parseLink` read item links with a `gmatch` pattern
  that, in WoW's Lua 5.1, emits an empty capture after every colon -- so the
  fields came out shifted and the enchant always read back as 0. Every
  enchantable slot showed "no enchant", and `/sp announce` with gear broadcast a
  phantom "8 missing enchants" to chat. Links are split with `strsplit` now,
  which keeps the fields aligned.
- **A render error could freeze the panel until `/reload`.** `Panel:Rebuild`
  set a re-entrancy flag and cleared it only at the very end, with nothing
  protecting the span between. Any error in that stretch left the flag stuck,
  turning every future rebuild into a permanent no-op that not even switching to
  a good profile could clear. The body runs under `pcall` now, so the flag
  always resets and the cause is reported instead of the panel silently dying.
- **A pasted import string with a wrong-typed value could brick the panel for
  good.** Imported and hand-edited profiles are type-checked against the schema
  on load: a value of the wrong type -- a string where a width belongs, a color
  channel that isn't a number -- is coerced back to its default before it can
  reach a `Set*` call and crash the render. With the freeze fix above, a bad
  string can no longer lock the panel across logins.
- **"Import into profile" shared its text box with "New profile name."** Typing
  an import target overwrote the create name, so the next Create made a
  wrongly-named profile. They are independent fields now.
- **The `$yards` value token could error every frame** when movement speed is
  delivered as a protected value, because it was formatted directly rather than
  through the secret-safe path. It degrades to 0 like the other guarded reads.

### Changed

- **Presets apply as complete looks.** A preset is a sparse table, so switching
  between two left behind any key the new one didn't mention -- Neon's spark and
  pink crit bar survived a switch to Modern Bars. Applying a preset now resets
  the look to defaults first, preserving only your position, visibility rules
  and account preferences. Per-stat color overrides are deep-copied too, so two
  profiles on the same preset no longer share (and mutate) one color table.
- Spec-change and vehicle events are filtered to the player. They carry a unit
  and fire for every group member, so an ally respeccing or taking a vehicle was
  forcing a full relayout on your panel.
- The rank and footer format strings -- free-text, and formatted every frame --
  are guarded: a stray specifier falls back to the default instead of erroring
  continuously.
- Import strings are capped in size, and the database version stamp is now read
  to gate migration instead of being written and never looked at.

## [2.0.2] - 2026-07-22

### Fixed

- **Announcing your speed never announced it.** The *Include peak speed* option
  called `SP.GetPeakSpeed`, which was never defined anywhere — the call
  short-circuited to nil and the field was dropped from the message with no
  error and nothing to indicate the setting did nothing. Speed is one of the
  few figures patch 12.0 does *not* protect, so it should always have been
  getting through. The accessor now exists.
- **The addon memory readout was the most expensive thing on the panel.**
  `UpdateAddOnMemoryUsage()` re-tallies memory for every loaded addon, not just
  this one, and it was being called from the footer build — which runs on the
  update loop, ten times a second at the default interval. It is now sampled
  every five seconds and reused in between. This only affected the footer's
  *Addon memory use* option, which is off by default.

### Added

- **Delve and Mythic+ dungeon rules for automatic profile switching.** Neither
  is its own instance type — a delve reports as a scenario and a key reports as
  an ordinary party dungeon — so both were previously indistinguishable from
  their untimed counterparts and fell into the generic rule. They are now told
  apart by difficulty and can carry their own profile. A specific rule falls
  back to its general one, so an existing *Dungeon* rule still applies inside a
  key unless you deliberately set a separate *Mythic+ dungeon* rule.

### Changed

- The LibDataBroker feed refreshed its text from an `OnUpdate` handler that ran
  every frame purely to discover it had nothing to do. It uses `C_Timer` now,
  and can no longer be started twice.
- `resolvePrimary` picks the largest of Strength / Agility / Intellect, which is
  a comparison — forbidden on a secret value, and the one read in the file that
  was not guarded against becoming one. Primary stats are readable today; if a
  patch ever protects them the row now displays under its own label instead of
  erroring and taking the panel down with it.

## [2.0.1] - 2026-07-21

### Fixed

- **Opposing visibility rules could hide the panel for good.** *Hide during
  combat* and *Show only during combat* were independent checkboxes, so ticking
  both left no state in which the panel was visible — it simply never appeared,
  with no error and nothing on screen to say which setting was responsible.
  *Hide inside instances* and *Hide outside instances* had the same problem.
  Each pair is now mutually exclusive: turning one on clears its opposite.
  Profiles already carrying a conflicting pair — from an import string, a
  hand-edited SavedVariables or a 1.x upgrade — are repaired when the profile
  loads.

## [2.0.0] - 2026-07-21

A rewrite. Everything the panel draws is now read from saved settings instead of
hardcoded constants, and the addon is split into focused modules.

### Fixed

- **Movement speed capped near the mount's rated maximum.** The code read the
  2nd and 3rd return values of `GetUnitSpeed`, which are the mount's *configured
  maxima* rather than actual velocity, and halved the result in some branches.
  Skyriding dives go far past those numbers. Speed is now taken from real
  velocity, preferring `C_PlayerInfo.GetGlidingInfo()` forward speed while
  gliding, so ground, flight, swimming and skyriding all work without
  special-casing the mount.
- **Hundreds of errors per minute on patch 12.0** from expanding value templates
  with `gsub`, which is forbidden for secret values. See *Changed* below.
- **Text could draw past the panel and over the game world.** Nothing bounded
  the fontstrings; every text element is now clamped and truncated, and
  auto-width accounts for the priority line.
- **The options panel could not be opened by ID** — `category.ID` was being set
  to the addon name, overwriting the numeric ID the game assigns.
- Auto-scaling bar ceilings were written into the saved profile. They are
  session state; they are now runtime-only, and stale copies are cleared on
  load.
- The live preview could render behind its own backdrop: `Rebuild` re-applied
  the saved frame strata, which outranks frame level.
- Closing the options could raise a taint error, because the canvas `OnHide`
  runs inside Blizzard's secure panel teardown.

### Changed

- **Formatting rebuilt around patch 12.0 secret values.** A `$token` template is
  compiled into a printf format string, and the secret is passed as an argument
  to `SetFormattedText` — one of the APIs permitted to receive one. Secrets can
  no longer reach `gsub`, arithmetic or a comparison. Widths are verified at the
  point of use, because a widget that has held a secret reports a secret width
  afterwards. Smoothing, auto-scaling and value gradients degrade instead of
  erroring.
- Options controls are built from raw frames rather than Blizzard's option
  templates, several of which have been removed across expansions.
- Stat values now default to the total effect shown on the character sheet;
  the previous rating-only behavior is still available as an option.

### Added

- Full appearance control: colors, textures, transparency, borders, fonts,
  sizes, padding, alignment and layout.
- A text-only row style (`Mastery: 285 - 10.65%`) alongside status bars.
- Token-based value formats per stat, and for the panel title.
- 21 presets, including two that match a live ElvUI installation's theme.
- Optional LibSharedMedia-3.0 support, soft-detected; nothing embedded.
- Parry, Block, Strength, Agility, Intellect, Stamina, and a "Primary" row that
  resolves to the character's actual scaling attribute.
- Sections can be renamed, reordered, and stats moved between them.
- Per-character profiles with import/export strings.
- Automatic profile switching by specialization or content type.
- LibDataBroker feed and a minimap button (defers to LibDBIcon when present).
- Right-click context menu on the panel and minimap button.
- Live preview docked beside the options window while configuring.
- Gear audit: per-slot item level, missing enchants, empty sockets.
- Chat announce, user-initiated and throttled, which omits any field the game
  protects and explains why.
- Session peak movement speed, with a `$peak` token.
- Visibility rules for combat, death, vehicles, pet battles and instances, plus
  mouseover fading.
- Slash commands: `/sp` with `toggle`, `lock`, `reset`, `preset`, `profile`,
  `gear`, `announce`, `peak` and `minimap`.

### Migration

Settings from 1.x are migrated automatically into a profile named `Default` on
first load. The old global entry points (`CreateStatPanel`, `ToggleStatPanel`,
`SPAddon_ApplyVisibility`) still work.

## [1.0.0] - 2024-10-22

Initial release: secondary stats in spec priority order, armor damage
reduction, movement speed and framerate, with a small options panel.
