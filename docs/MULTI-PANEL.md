# Design note: a second panel

**Status:** designed, not built. This documents why, and what building it
actually costs, so the next attempt starts from the measurement rather than
from the guess.

## What people are asking for

Two independently positioned panels — the usual case being defensives in one
corner and secondaries in another, or a large readout on one monitor and a
compact one near the action bars. Sections already let you *group* stats; what
they can't do is put a group somewhere else on the screen.

## Why it isn't a small change

The addon is built around exactly one panel, and that assumption is load
bearing in four places. Measured against the current source:

| Assumption | Where | Size |
| --- | --- | --- |
| One frame | `frame` is a file-local upvalue in `StatPanel.lua` | 135 references |
| One panel object | `Panel` is a singleton table, not a class | 20 methods |
| One config block | `panel`, `bars`, `font`, `footer`, `sections` are top-level | — |
| One binding namespace | `Options.lua` binds widgets by literal path | 111 of 122 bindings |

The options window is the expensive part and the easy part to underestimate.
Every control is bound with a literal string — `path = "panel.bgColor"` — and
in a multi-panel world every one of those has to resolve against *the panel
currently being edited*. That is 111 bindings plus a panel selector plus a
notion of "current panel" threaded through page construction and refresh.

And it is a saved-variables schema change. Today a profile is:

```
profile = { panel = {...}, bars = {...}, font = {...}, sections = {...}, ... }
```

Multi-panel wants:

```
profile = { panels = { { panel = {...}, bars = {...}, ... }, { ... } } }
```

That is a `DB_VERSION` 2 → 3 migration that runs once, on data nobody can
reproduce afterwards, for every existing user. `Config:Init` has the gate for
it already, and `tests/spec_profiles.lua` has the shape of the test — but this
is the single riskiest thing that could be done to this addon, and it is not
worth doing hurriedly.

## Staged plan

Each stage is shippable on its own and leaves the addon working.

**1. Make `Panel` a class, keep one instance.** Move `frame` onto `self`,
convert the 20 methods to operate on `self.frame`, and have `SP:CreatePanel()`
return an instance stored in `SP.panels[1]`. No config change, no user-visible
change, nothing to migrate. The whole of `tests/` should stay green throughout;
if it doesn't, that is the refactor telling you something.

**2. Give the options window a current-panel indirection.** Introduce
`Config:Get`/`Set` paths that resolve relative to a selected panel index —
`"@.panel.bgColor"` rather than `"panel.bgColor"` — with the selection fixed at
1. Again invisible, again nothing to migrate. This is the 111-binding stage and
should be done mechanically, not by hand.

**3. The schema migration.** `DB_VERSION` 3: wrap the existing five blocks into
`panels[1]`. Write the migration test *first*, against a real v2 profile
captured from a live SavedVariables file. `sanitize` needs a variable-length
list of subtrees, which it already handles — that is the `#schema > 0 and
type(schema[1]) == "table"` branch.

**4. Actually add a second panel.** A panel selector in the options, an
add/remove/duplicate row, and per-panel enable. Presets apply to the selected
panel. Import/export gains a "this string contains N panels" case.

Stages 1–3 are refactors with tests as the safety net. Only stage 4 is a
feature, and by then it is a small one.

## Cheaper things that solve part of the problem

Worth considering before committing to the above, because between them they
cover a good share of what people actually want:

- **Per-section anchoring** — let a section detach to its own screen position
  while staying one panel logically. Smaller than multi-panel, but it is still
  a layout refactor of `Panel:RebuildInner`, and it does not give you a second
  background, border or title.
- **Profile switching by content** — already shipped. "Tank layout in raids"
  does not need two panels if you never need both at once.
- **A second profile on a second character** — already shipped, and covers the
  "different setup per alt" reading of the request entirely.
