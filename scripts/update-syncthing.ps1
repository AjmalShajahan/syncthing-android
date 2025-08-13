# Checking for Syncthing Update
# -----------------------------

param(
    [string]$LATEST_TAG
)

$ErrorActionPreference = "Stop"

Write-Host "`nChecking for Syncthing Update`n-----------------------------`n"

# Get project directory (parent of script location)
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$PROJECT_DIR = Resolve-Path (Join-Path $SCRIPT_DIR "..")

# Change to syncthing source directory
$SYNCTHING_DIR = Join-Path $PROJECT_DIR "syncthing/src/github.com/syncthing/syncthing"
Set-Location $SYNCTHING_DIR

git fetch

$CURRENT_TAG = git describe

if (-not $LATEST_TAG) {
    $LATEST_TAG = git tag --sort=taggerdate | Select-Object -Last 1
}

if ($CURRENT_TAG -ne $LATEST_TAG) {
    git checkout -f $LATEST_TAG
    Set-Location $PROJECT_DIR
    git add "syncthing/src/github.com/syncthing/syncthing/"
    git commit -m "Updated Syncthing to $LATEST_TAG"
} else {
    Write-Host "Syncthing up-to-date at $CURRENT_TAG"
}

Set-Location $PROJECT_DIR
