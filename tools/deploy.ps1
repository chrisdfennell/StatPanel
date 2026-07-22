<#
    StatPanel deploy script.

    The project source lives on the NAS (F:\Programming\LUA\StatPanel\StatPanel), which is a
    network drive -- so junctions/symlinks into WoW's AddOns folder don't work and
    loading over the network would be slow. Instead we mirror the addon into the
    local WoW AddOns folder on demand.

    Usage (from the project, or anywhere):
        pwsh -File Tools\deploy.ps1
        pwsh -File Tools\deploy.ps1 -Watch     # redeploy automatically on file change

    Only the files WoW actually needs are copied; dev-only files (tests, tools,
    docs, VCS) are excluded so the loaded addon stays clean.
#>
param(
    [string]$Source = (Split-Path $PSScriptRoot -Parent),
    [string]$WowRoot = 'C:\Program Files (x86)\World of Warcraft\_retail_',
    [switch]$Watch
)

$ErrorActionPreference = 'Stop'
$dest = Join-Path $WowRoot 'Interface\AddOns\StatPanel'

function Invoke-Deploy {
    # /MIR mirror; exclude dev-only dirs and files. robocopy returns bit-flag
    # exit codes where anything < 8 means success.
    $roboArgs = @(
        $Source, $dest,
        '/MIR',
        '/XD', 'Tests', 'Tools', '.git', '.vscode', '.claude',
        '/XF', '*.md', '*.ps1', '.gitignore', '.luarc.json',
        '/NFL', '/NDL', '/NJH', '/NJS', '/NP'
    )
    robocopy @roboArgs | Out-Null
    $code = $LASTEXITCODE
    if ($code -ge 8) {
        Write-Error "robocopy failed (exit $code)"
    } else {
        $stamp = (Get-Date).ToString('HH:mm:ss')
        Write-Host "[$stamp] Deployed -> $dest" -ForegroundColor Green
    }
}

Invoke-Deploy

if (-not $Watch) {
    # robocopy leaves a non-zero (bit-flag) exit code even on success; normalize
    # so callers/CI don't misread a successful deploy as a failure.
    exit 0
}

if ($Watch) {
    Write-Host "Watching $Source for changes (Ctrl+C to stop)..." -ForegroundColor Cyan
    $fsw = New-Object System.IO.FileSystemWatcher $Source, '*.*'
    $fsw.IncludeSubdirectories = $true
    $fsw.EnableRaisingEvents = $true
    # Debounce: collect rapid saves, redeploy at most every ~1s.
    while ($true) {
        $changed = $fsw.WaitForChanged([System.IO.WatcherChangeTypes]::All, 1000)
        if (-not $changed.TimedOut) {
            Start-Sleep -Milliseconds 250
            try { Invoke-Deploy } catch { Write-Warning $_ }
        }
    }
}
