# StatPanel

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Interface](https://img.shields.io/badge/WoW-12.0%20Midnight-orange.svg)
![Lua](https://img.shields.io/badge/Lua-5.1-000080.svg)

A movable panel for World of Warcraft showing your secondary stats in your
specialization's priority order, alongside item level, movement speed and
framerate — with essentially every pixel of it configurable.

Colors, textures, transparency, borders, fonts, sizes, layout, which stats
appear and how their numbers are written are all options. If you would rather
not configure anything, pick one of the 21 presets and you are done.

<!-- Add a screenshot here once you have one:
     ![StatPanel](docs/screenshot.png)
-->

---

## Features

**Appearance**
- Two row styles: status bars, or a text-only readout (`Mastery: 285 - 10.65%`)
- Per-stat colors, or class color / single color / value gradient
- Panel and bar textures, borders and transparency
- Font face, size, outline, shadow and color, per text element
- Auto-sizing width, or a fixed width you choose

**Stats**
- Crit, Haste, Mastery, Versatility ordered by your spec's priority
- Armor damage reduction, Dodge, Parry, Block
- Leech, Avoidance, Movement speed with a session peak
- Strength / Agility / Intellect / Stamina, plus a "Primary" row that resolves
  to whichever attribute your character actually scales with
- Sections can be renamed, reordered, and any stat moved between them

**Quality of life**
- Per-character profiles, with import/export strings for sharing
- Automatic profile switching by specialization or content type
- Live preview docked beside the options window while you configure
- Right-click menu on the panel for quick toggles, presets and profiles
- Minimap button and a LibDataBroker feed
- Gear audit: per-slot item level, missing enchants, empty sockets
- Chat announce for your gear summary

---

## Installation

Copy the `StatPanel` folder into:

```
World of Warcraft/_retail_/Interface/AddOns/
```

Then restart the game (or `/reload` if the addon was already installed with the
same file list). Type `/sp` to open the options.

**Optional:** if any addon you run provides
[LibSharedMedia-3.0](https://www.curseforge.com/wow/addons/libsharedmedia-3-0)
— ElvUI, WeakAuras, Details!, Plater and many others do — every texture and font
registered with it appears in StatPanel's dropdowns automatically. Nothing is
embedded and nothing is required.

---

## Quick start

| Want | Do |
| --- | --- |
| Open the options | `/sp` |
| Try a different look | Options → **Presets** |
| Move the panel | Drag it (untick **Lock position** first) |
| Quick toggles | Right-click the panel |
| Check your enchants | `/sp gear` |

### Presets

| Preset | Looks like |
| --- | --- |
| Modern Bars | The default: flat dark panel with colored bars |
| Classic Text | No bars — one colored line per stat, with ratings |
| Compact Bars | Thin headerless bars, small footprint |
| Blizzard | Blizzard textures and a tooltip border |
| Transparent | No background or border at all |
| Minimal Mono | Tiny monochrome text in a corner |
| Neon | High-contrast glow bars with a spark |
| Parchment | Warm parchment and gold |
| Frostbound / Ember | Cool blue / warm red themes |
| Class Colored | Every bar in your class color |
| Big & Bold | Large high-contrast text, readable at a distance |
| Ultra Compact | Four secondaries, nothing else |
| Terminal | Green-on-black console readout |
| ElvUI / ElvUI Transparent | Matches your ElvUI theme (see below) |
| Tank / Healer / PvP | Role-appropriate stat selections |
| Speedrunner | Big live speed with your session record |
| Raid Ready | Secondaries, item level and both latencies |

The two **ElvUI** presets read your *live* ElvUI configuration — border color,
backdrop color, texture, font and font size — so StatPanel matches whatever you
have themed it to. Without ElvUI installed they fall back to a static
approximation and still work.

---

## Slash commands

| Command | Does |
| --- | --- |
| `/sp` | Open the options |
| `/sp toggle` | Show or hide the panel |
| `/sp lock` | Lock or unlock dragging |
| `/sp reset` | Move the panel back to the center |
| `/sp preset <name>` | Apply a preset |
| `/sp profile <name>` | Switch profiles (no name lists them) |
| `/sp gear` | Audit enchants, sockets and item level |
| `/sp announce [channel]` | Report your gear to chat |
| `/sp peak` | Clear the session speed record |
| `/sp minimap` | Show or hide the minimap button |

`/statpanel` works as a longer alias for all of the above.

---

## Value formats

Each stat's text is a small template. Write whatever you like:

| Token | Gives |
| --- | --- |
| `$value` | The headline number, to your chosen decimals |
| `$rating` | The raw combat rating behind it |
| `$valuec` / `$ratingc` | The same, with thousands separators |
| `$label` | The stat's display name |
| `$max` | The configured bar maximum |
| `$peak` | Session peak (movement speed) |
| `$yards` | Yards per second (movement speed) |

So `$rating - $value%` renders as `285 - 10.65%`.

The title has its own tokens: `$equipped`, `$overall`, `$name`, `$spec`,
`$class`, `$level`. `iLvl: $equipped / $overall` gives
`iLvl: 226.06 / 228.19`.

---

## A note on patch 12.0 "secret values"

Midnight introduced **secret values**: most combat statistics are handed to
addons in a form that can be *displayed* but not *read*. An addon may not do
arithmetic on them, compare them, or send them anywhere.

StatPanel is built for this, and shows your stats normally. A few features
cannot work on a protected value and degrade quietly rather than failing:

- Bar smoothing jumps straight to the value instead of easing
- Auto-scaling bar maximums stop growing
- The value-gradient color mode parks at its low end
- Auto-width cannot measure that row
- **Chat announce omits those stats** — no addon is permitted to send them

Item level, movement speed, spec and all gear data are *not* protected, so those
work fully everywhere, including announce.

If a future patch changes what is protected, StatPanel picks that up on its own
with no update needed.

---

## Profiles

Each character remembers which profile it uses, so alts can share one look or
each have their own. Profiles can be copied, and exported to a string you can
paste to someone else.

**Automation** (in the options) can switch profiles for you — by specialization,
or by where you are (raid, dungeon, arena, battleground, open world). A content
rule beats a spec rule, so "Tank profile for Protection, but always Raid Ready
inside a raid" works as you would expect. Rules are per character, and nothing
switches unless you set a rule.

---

## Development

The addon is plain Lua with no build step. Files load in the order listed in
`StatPanel.toc`, and each depends on the ones before it.

| File | Holds |
| --- | --- |
| `Media.lua` | Texture / font / border registry, LibSharedMedia bridge |
| `Config.lua` | Defaults schema, profiles, import/export |
| `Presets.lua` | The 21 one-click looks |
| `Widgets.lua` | Option controls, built from raw frames |
| `StatPanel.lua` | The panel: stat sources, layout, rendering |
| `Gear.lua` | Equipped item audit |
| `Announce.lua` | Chat reporting |
| `AutoProfile.lua` | Profile switching rules |
| `Menu.lua` | Right-click context menu |
| `Broker.lua` | LibDataBroker feed and minimap button |
| `Options.lua` | The options window |
| `SPMain.lua` | Initialization and slash commands |

`tools/deploy.ps1` mirrors the addon into your live AddOns folder:

```powershell
pwsh -File tools/deploy.ps1            # deploy once
pwsh -File tools/deploy.ps1 -Watch     # redeploy on every save
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for coding conventions and the pitfalls
worth knowing about (secret values, deprecated Blizzard templates, taint), and
[docs/PUBLISHING.md](docs/PUBLISHING.md) for cutting a release and getting onto
CurseForge.

Releases are automated: push a `v*` tag and CI builds the zip, attaches it to a
GitHub release, and uploads it anywhere a token is configured.

---

## License

[MIT](LICENSE).
