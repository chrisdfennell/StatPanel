<#
    StatPanel locale linter.

    SP.L is deliberately forgiving: a key with no translation falls back to
    English, and a key with no entry at all falls back to itself. That is the
    right behaviour at runtime, but it also means the two mistakes a translator
    actually makes are completely silent -- a mistyped key looks fine (it just
    renders the typo'd English), and a translation that drops or reorders a
    format specifier only blows up on the line of code that calls :format().

    This script is where those get caught.

    Usage (from anywhere):
        pwsh -File tools\locale-lint.ps1
        pwsh -File tools\locale-lint.ps1 -Locale deDE      # one locale only
        pwsh -File tools\locale-lint.ps1 -Export frFR      # print a stub to fill in

    Exit code is 1 if any error was found, 0 otherwise, so CI can gate on it.
    Untranslated keys are reported as coverage, not as errors -- partial
    translations are supported on purpose.
#>
param(
    [string]$Source = (Split-Path $PSScriptRoot -Parent),
    [string]$Locale,
    [string]$Export
)

$ErrorActionPreference = 'Stop'

$localesDir = Join-Path $Source 'Locales'
$tocPath    = Join-Path $Source 'StatPanel.toc'
$errors     = 0

function Write-Err  ($msg) { $script:errors++; Write-Host "  ERROR  $msg" -ForegroundColor Red }
function Write-Warn ($msg) { Write-Host "  WARN   $msg" -ForegroundColor Yellow }
function Write-Ok   ($msg) { Write-Host "  ok     $msg" -ForegroundColor DarkGray }

#------------------------------------------------------------------------------
# Format specifiers
#------------------------------------------------------------------------------
# Lua's string.format accepts C-style specifiers plus %q. "%%" is a literal
# percent and carries no argument, so it is skipped. A translation must consume
# exactly the same arguments as its key or :format() errors at runtime.
function Get-FormatSpecs ($text) {
    $out = @()
    foreach ($m in [regex]::Matches($text, '%(%|\d+\$?[-+ #0]*[\d.]*[diouxXeEfgGqscaA]|[-+ #0]*[\d.]*[diouxXeEfgGqscaA])')) {
        if ($m.Value -ne '%%') { $out += $m.Value }
    }
    return , $out
}

#------------------------------------------------------------------------------
# Keys used by the addon
#------------------------------------------------------------------------------
# Two shapes reach SP.L:
#   L["some string"]                     -- the ordinary lookup
#   SP.Global("HEADSLOT", "Head")        -- client string first, key as fallback
# The second argument of SP.Global is a real SP.L key, so a translator may
# override it and the linter must not call that override orphaned.
$usedKeys = [ordered]@{}

$sourceFiles = Get-ChildItem -Path $Source -Filter '*.lua' -File |
    Where-Object { $_.DirectoryName -ne $localesDir }

foreach ($file in $sourceFiles) {
    $text = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $rel  = $file.Name

    foreach ($m in [regex]::Matches($text, 'L\[\s*"((?:[^"\\]|\\.)*)"\s*\]')) {
        $key = $m.Groups[1].Value
        if ($key -eq '') { continue }
        if (-not $usedKeys.Contains($key)) { $usedKeys[$key] = @() }
        $usedKeys[$key] += $rel
    }

    foreach ($m in [regex]::Matches($text, '(?:SP\.Global|\bG)\(\s*"[^"]+"\s*,\s*"((?:[^"\\]|\\.)*)"\s*\)')) {
        $key = $m.Groups[1].Value
        if (-not $usedKeys.Contains($key)) { $usedKeys[$key] = @() }
        $usedKeys[$key] += $rel
    }
}

Write-Host "`nStatPanel locale lint" -ForegroundColor Cyan
Write-Host "  $($usedKeys.Count) keys across $($sourceFiles.Count) source files`n"

#------------------------------------------------------------------------------
# -Export: print a ready-to-translate stub
#------------------------------------------------------------------------------
if ($Export) {
    $existing = @{}
    $exportFile = Join-Path $localesDir "$Export.lua"
    if (Test-Path $exportFile) {
        $text = Get-Content -Path $exportFile -Raw -Encoding UTF8
        foreach ($m in [regex]::Matches($text, 'L\[\s*"((?:[^"\\]|\\.)*)"\s*\]\s*=')) {
            $existing[$m.Groups[1].Value] = $true
        }
    }

    Write-Host "local _, SP = ..."
    Write-Host "local L = SP.Locale(`"$Export`")"
    Write-Host ""
    foreach ($key in $usedKeys.Keys) {
        if ($existing.ContainsKey($key)) { continue }
        # Commented out so the stub is valid Lua as-is: a translator uncomments
        # the lines they finish, and the rest keep falling back to English.
        Write-Host "-- L[`"$key`"] = `"$key`""
    }
    exit 0
}

#------------------------------------------------------------------------------
# Each locale file
#------------------------------------------------------------------------------
if (-not (Test-Path $localesDir)) {
    Write-Warn "no Locales directory at $localesDir"
    exit 0
}

$localeFiles = Get-ChildItem -Path $localesDir -Filter '*.lua' -File
if ($Locale) { $localeFiles = $localeFiles | Where-Object { $_.BaseName -eq $Locale } }

if (-not $localeFiles) {
    Write-Warn 'no locale files found -- the framework is unexercised'
    exit 0
}

$toc = if (Test-Path $tocPath) { Get-Content -Path $tocPath -Raw -Encoding UTF8 } else { '' }

foreach ($file in $localeFiles) {
    $name = $file.BaseName
    Write-Host "Locales\$($file.Name)" -ForegroundColor White

    $text = Get-Content -Path $file.FullName -Raw -Encoding UTF8

    # A file that doesn't call SP.Locale with its own name would either write
    # onto the wrong table or, worse, onto SP.L on every client.
    if ($text -notmatch "SP\.Locale\(\s*[`"']$([regex]::Escape($name))[`"']\s*\)") {
        Write-Err "does not call SP.Locale(`"$name`") -- check the locale argument matches the filename"
    }

    # The .toc drives load order; a file that isn't listed simply never loads.
    if ($toc -notmatch "(?im)^\s*Locales[\\/]$([regex]::Escape($file.Name))\s*$") {
        Write-Err "not listed in StatPanel.toc -- it will never load"
    }

    $translated = 0
    $seen = @{}

    foreach ($m in [regex]::Matches($text, 'L\[\s*"((?:[^"\\]|\\.)*)"\s*\]\s*=\s*"((?:[^"\\]|\\.)*)"')) {
        $key   = $m.Groups[1].Value
        $value = $m.Groups[2].Value

        if ($seen.ContainsKey($key)) {
            Write-Err "duplicate entry for `"$key`" -- the later one silently wins"
            continue
        }
        $seen[$key] = $true

        if (-not $usedKeys.Contains($key)) {
            # The silent one: a typo here reads as a missing translation, and
            # the English text keeps rendering, so nobody ever notices.
            Write-Err "orphaned key `"$key`" -- no such string in the source (typo?)"
            continue
        }

        if ($value -eq '') {
            Write-Err "empty translation for `"$key`" -- delete the line instead so it falls back"
            continue
        }

        $keySpecs   = Get-FormatSpecs $key
        $valueSpecs = Get-FormatSpecs $value

        if ($keySpecs.Count -ne $valueSpecs.Count) {
            Write-Err ("`"$key`" takes $($keySpecs.Count) format argument(s), " +
                       "translation takes $($valueSpecs.Count) -- :format() will error")
        }
        elseif ($keySpecs.Count -gt 0) {
            $positional = $valueSpecs | Where-Object { $_ -match '^%\d+\$' }
            if ($positional) {
                # %1$s style: the translator has explicitly reordered, which is
                # the supported way to do it. Only the count matters.
            }
            elseif ((Compare-Object $keySpecs $valueSpecs -SyncWindow 0)) {
                Write-Err ("`"$key`" specifiers [$($keySpecs -join ' ')] do not match " +
                           "translation [$($valueSpecs -join ' ')] -- use %1`$s style to reorder")
            }
        }

        $translated++
    }

    $missing = @($usedKeys.Keys | Where-Object { -not $seen.ContainsKey($_) })
    $pct = if ($usedKeys.Count -gt 0) { [math]::Round(100 * $translated / $usedKeys.Count) } else { 100 }

    Write-Ok "$translated/$($usedKeys.Count) keys translated ($pct%)"
    if ($missing.Count -gt 0) {
        Write-Host "         $($missing.Count) untranslated, falling back to English" -ForegroundColor DarkGray
    }
    Write-Host ''
}

if ($errors -gt 0) {
    Write-Host "$errors error(s)`n" -ForegroundColor Red
    exit 1
}

Write-Host "No errors.`n" -ForegroundColor Green
exit 0
