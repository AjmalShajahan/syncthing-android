#requires -Version 5.0

# Exit on error
$ErrorActionPreference = "Stop"

# Check for clean git workspace
$gitStatus = git diff-index --exit-code --quiet HEAD 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Bumping version aka cutting a release must happen on a clean git workspace"
    exit 1
}

# Get new version name from argument
$NEW_VERSION_NAME = $args[0]
$OLD_VERSION_NAME = Select-String 'versionName' "app/build.gradle.kts" | ForEach-Object {
    $_.Line.Split()[-1]
}
if ([string]::IsNullOrWhiteSpace($NEW_VERSION_NAME)) {
    Write-Host "New version name is empty. Please set a new version. Current version: $OLD_VERSION_NAME"
    exit 1
}

# Run version check script
& ./scripts/check-version.ps1 $NEW_VERSION_NAME

Write-Host "`nRunning Lint`n-----------------------------`n"
& ./gradlew clean lintVitalRelease

Write-Host "`nEnter Changelog for $NEW_VERSION_NAME`n-----------------------------`n"
$CHANGELOG = "app/src/main/play/release-notes/en-GB/default.txt"
if (Get-Command edit -ErrorAction SilentlyContinue) {
    $editor = "edit"
} elseif ($env:EDITOR) {
    $editor = $env:EDITOR
} else {
    Write-Host "No editor found - need either 'edit' binary or EDITOR env var set"
    exit 1
}
& $editor $CHANGELOG

Write-Host "`nUpdating Version`n-----------------------------`n"
$OLD_VERSION_CODE = Select-String 'versionCode' "app/build.gradle.kts" | Select-Object -First 1 | ForEach-Object {
    $_.Line.Split()[-1]
}
$NEW_VERSION_CODE = [int]$OLD_VERSION_CODE + 1

(Get-Content "app/build.gradle.kts") -replace "versionCode = $OLD_VERSION_CODE", "versionCode = $NEW_VERSION_CODE" | Set-Content "app/build.gradle.kts"

$OLD_VERSION_NAME = Select-String 'versionName' "app/build.gradle.kts" | ForEach-Object {
    $_.Line.Split()[-1]
}
(Get-Content "app/build.gradle.kts") -replace "$OLD_VERSION_NAME", "`"$NEW_VERSION_NAME`"" | Set-Content "app/build.gradle.kts"

git add "app/build.gradle.kts" $CHANGELOG
git commit -m "Bumped version to $NEW_VERSION_NAME"

$changelogContent = Get-Content $CHANGELOG | Out-String
git tag -a $NEW_VERSION_NAME -m "$NEW_VERSION_NAME`n`n$changelogContent"
