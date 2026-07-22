# Publishing StatPanel

Releases are automated, but getting on CurseForge the first time involves a few
steps only you can do. This walks through both.

## Cutting a release

```powershell
git tag -a v2.0.0 -m "2.0.0"
git push origin v2.0.0
```

That is the whole process. The `Release` workflow then:

1. Builds `StatPanel-2.0.0.zip` with the correct internal folder structure
2. Creates a GitHub release and attaches the zip
3. Uploads to CurseForge, Wago and WoWInterface — for each one you have added a
   token for; the rest are skipped silently
4. Prints the zip's file list to the run summary so you can see what shipped

Tag names should match the `## Version:` field in `StatPanel.toc`. Update the
TOC version and `CHANGELOG.md` in the same commit you tag.

### Testing without publishing

From the **Actions** tab, run **Release** manually with **dry run** ticked. It
builds the zip and attaches it to the run as an artifact without uploading or
creating a release. Download it and confirm the contents look right — this is
worth doing before your first real tag.

## Getting on CurseForge

### 1. Create the project

Sign in at [curseforge.com](https://www.curseforge.com/) and create a new World
of Warcraft addon project. You will need:

- **Name** — StatPanel
- **Summary** — a sentence or two; the README's opening paragraph works
- **Category** — something like *Unit Frames* or *Miscellaneous*
- **License** — MIT, to match `LICENSE`
- **Description** — the README body is a good starting point

New projects are reviewed by CurseForge staff before going public. Approval is
usually quick but is not instant, and your first file upload may sit in a queue.

### 2. Add the project ID to the TOC

Your project page URL ends in a numeric ID. Uncomment the line in
`StatPanel.toc` and fill it in:

```
## X-Curse-Project-ID: 123456
```

The packager reads it from there; without it, it does not know where to upload.

### 3. Add the API token as a repository secret

Generate a token at
[legacy.curseforge.com/account/api-tokens](https://legacy.curseforge.com/account/api-tokens),
then in GitHub go to **Settings → Secrets and variables → Actions → New
repository secret**:

| Secret | For |
| --- | --- |
| `CF_API_TOKEN` | CurseForge |
| `WAGO_API_TOKEN` | Wago Addons (optional) |
| `WOWI_API_TOKEN` | WoWInterface (optional) |

`GITHUB_TOKEN` is provided automatically — you do not add that one.

### 4. Tag a release

From here on, pushing a version tag publishes everywhere in one go.

## Getting the game version right

`## Interface:` in the TOC must match the live client, or CurseForge flags the
file as out of date and users get an "incompatible" warning.

Find the current value in-game:

```
/dump select(4, GetBuildInfo())
```

It is the expansion, major and minor patch zero-padded to two digits each:
patch 12.0.5 is `120005`. Bump it whenever a patch lands, even if nothing else
in the addon changes.

To support several game flavours from one repo, see the `-S` flag and
multi-TOC naming (`StatPanel_Mainline.toc`, `StatPanel_Classic.toc`) in the
[packager documentation](https://github.com/BigWigsMods/packager).

## What ends up in the zip

`.pkgmeta` controls this. Development files are excluded:

| Shipped | Excluded |
| --- | --- |
| All `.lua` files | `.github/` |
| `StatPanel.toc` | `tools/` |
| `README.md` | `.vscode/` |
| `CHANGELOG.md` | `.luacheckrc`, `.editorconfig`, `.gitignore` |
| `LICENSE` | `CONTRIBUTING.md` |

Inside the zip, everything sits under a single `StatPanel/` folder, which is
what lets users drop it straight into `Interface/AddOns`. That comes from
`package-as: StatPanel` in `.pkgmeta` — this repo keeps the addon files at the
root rather than in a subfolder, so without that directive the zip would
unpack loose into the AddOns folder.

## Release checklist

- [ ] `## Version:` in the TOC matches the tag you are about to push
- [ ] `## Interface:` matches the current live patch
- [ ] `CHANGELOG.md` has an entry for this version
- [ ] Dry run produced a zip with the expected contents
- [ ] Loaded the built zip in-game once, from a clean AddOns folder
