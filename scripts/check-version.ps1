Write-Host "`nChecking Syncthing Version is compatible"
Write-Host "-----------------------------`n"

$NEW_VERSION_NAME = $args[0]
if ([string]::IsNullOrEmpty($NEW_VERSION_NAME)) {
    Write-Host "New version name is empty. Please set a new version."
    exit 1
}

Push-Location "syncthing/src/github.com/syncthing/syncthing/"
$CURRENT_TAG = git describe
Pop-Location

# Remove leading 'v' from CURRENT_TAG if present
$CURRENT_TAG_NO_V = $CURRENT_TAG -replace '^v', ''

if ($NEW_VERSION_NAME -ne $CURRENT_TAG_NO_V) {
    Write-Host ("New version name {0} is not compatible with Syncthing version {1}" -f $NEW_VERSION_NAME, $CURRENT_TAG)
    exit 1
}
Write-Host ("New version name {0} is compatible with Syncthing version {1}" -f $NEW_VERSION_NAME, $CURRENT_TAG)
