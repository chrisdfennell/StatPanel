# Changelog

All notable changes to StatPanel are recorded here.

This project follows [Semantic Versioning](https://semver.org/) and the format
of [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

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
