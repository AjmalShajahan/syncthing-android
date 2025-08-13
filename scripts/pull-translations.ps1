Write-Host "Pulling Translations"
Write-Host "-----------------------------"

# Start tx pull commands in parallel jobs
$jobs = @()
$jobs += Start-Job -ScriptBlock { tx pull -a -f "syncthing-android.stringsxml" }
$jobs += Start-Job -ScriptBlock { tx pull -a -f "syncthing-android.description_fulltxt" }
$jobs += Start-Job -ScriptBlock { tx pull -a -f "syncthing-android.description_shorttxt" }
$jobs += Start-Job -ScriptBlock { tx pull -a -f "syncthing-android.titletxt" }

# Wait for all jobs to finish
$jobs | ForEach-Object { Wait-Job $_; Receive-Job $_; Remove-Job $_ }

# Run gradle task
./gradlew deleteUnsupportedPlayTranslations

# Add files to git
git add -A "app/src/main/play/"
git add -A "app/src/main/res/values-*/strings.xml"

# Check for staged changes and commit if needed
$diff = git diff --cached --exit-code
if ($LASTEXITCODE -ne 0) {
    git commit -m "Imported translations"
}
