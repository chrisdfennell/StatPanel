# Changelog

All notable changes to StatPanel are recorded here.

This project follows [Semantic Versioning](https://semver.org/) and the format
of [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

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
