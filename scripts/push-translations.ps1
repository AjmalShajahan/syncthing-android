try {
    Write-Host "Pushing Translations"
    Write-Host "-----------------------------"
    tx push -s
} catch {
    Write-Error "Failed to push translations."
    exit 1
}
