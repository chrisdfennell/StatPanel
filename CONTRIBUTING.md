# Contributing to StatPanel

Thanks for taking an interest. This document covers how to get set up, the
conventions the code follows, and — most usefully — the pitfalls that have
already bitten this addon, so they don't bite you too.

## Getting set up

There is no build step. Clone the repo into your AddOns folder, or work
anywhere and use the deploy script:

```powershell
pwsh -File tools/deploy.ps1            # mirror into the live AddOns folder
pwsh -File tools/deploy.ps1 -Watch     # redeploy on every save
```

Pass `-WowRoot` if your installation isn't at the default path.

Files load in the order listed in `StatPanel.toc` and each depends on the ones
above it. **A new `.lua` file that isn't added to the TOC will never load** —
the CI check catches this.

## Before opening a pull request

Please make sure:

1. Every file parses. CI runs `luacheck`; you can run it locally the same way.
2. Any new file is listed in `StatPanel.toc`.
3. Any new option has a matching entry in the defaults schema in `Config.lua` —
   an option bound to a path that doesn't exist silently does nothing.
4. You have loaded it in-game at least once. Static checks catch syntax and
   wiring, not behavior.

Say plainly in the PR what you tested in-game and what you didn't. "I couldn't
test this part" is genuinely useful; a claim that turns out to be untrue is not.

## Conventions

- **Match the surrounding code.** Comment density here is fairly high, and
  comments explain *why*, not *what*.
- Wrap at roughly 80 columns.
- Locals over globals. Each file starts with `local addonName, SP = ...` and
  hangs its module off `SP`.
- Prefer descriptive names to short ones. `damageReductionCurrentTarget` beats
  `drCur`.
- Guard optional APIs rather than assuming they exist — see the shims at the
  top of `StatPanel.lua`.

## Three things that will bite you

### 1. Secret values (patch 12.0)

Most combat stats now arrive as **secret values**. You may store them, pass
them around, and hand them to a small set of display APIs. You may **not**:

- do arithmetic on them
- compare them or use them in a boolean test
- take their length
- use them as a table key
- **use one as a `gsub` replacement**

That last one caused hundreds of errors a minute before it was found. The fix
pattern is in `buildFormat()` in `StatPanel.lua`: compile the `$token` template
into a printf format string — touching only ordinary text — then pass the secret
as an *argument* to `SetFormattedText`, which is permitted to receive it.

The subtle trap: once a widget has been given a secret, **the widget itself is
marked as holding secrets**, so `GetStringWidth()` returns a secret number on
every later frame, even when the current value is ordinary again. Checking the
incoming value is not sufficient. `stringWidth()` shows the pattern — verify at
the point of use and return `nil` when a value can't be trusted.

Use `SP.PlainNumber(value)`, which returns the number only when it is provably
safe for arithmetic, and `nil` otherwise.

### 2. Blizzard templates disappear

`InterfaceOptionsCheckButtonTemplate`, `UIDropDownMenu` and
`OptionsSliderTemplate` have all been deprecated or removed across expansions.
`Widgets.lua` builds every control from raw frames and textures for exactly this
reason. Please don't reintroduce a dependency on an options template.

Also don't set `category.ID` on a Settings category — it overwrites the numeric
ID the game assigned and breaks opening the panel.

### 3. Taint and secure code paths

Anything attached to the Settings canvas (`OnShow`, `OnHide`) is called from
inside Blizzard's secure panel machinery. Doing real work there runs your
tainted code inside their call and produces *"action only available to the
Blizzard UI"*. Defer it with `C_Timer.After(0, ...)`, as `StartPreview` and
`StopPreview` do.

## Adding things

**A new option:** add it to the `DEFAULTS` table in `Config.lua`, then bind a
widget to it in `Options.lua` with `path = "group.key"`. Read it in
`Panel:Rebuild()`. `SP:Refresh()` re-reads everything, so there is no need to
write a targeted updater.

**A new stat:** add an entry to `STAT_DEFS` in `StatPanel.lua` with a `get`
function returning `value, rating`, add display defaults under `stats` in
`Config.lua`, and add its name to `SP.STAT_ORDER`. Route any arithmetic through
`SP.PlainNumber`.

**A new preset:** add a sparse table to `Presets.list` and its name to
`Presets.order`. Only list the keys you actually want to change. A `dynamic`
function runs after the preset is applied, if it needs to adapt to what is
installed — see the ElvUI presets.

## Reporting bugs

The **full error text** matters more than anything else. A line number alone
usually isn't enough to identify the cause, and the first line of the message is
frequently the whole answer. Include your addon version, game version, and
whether other addons are loaded.
