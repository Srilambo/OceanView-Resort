$files = @(
    "d:\ap\p2\OceanView-Resort\frontend\lib\features\user\accommodation\screens\accommodation_screen.dart",
    "d:\ap\p2\OceanView-Resort\frontend\lib\features\user\amenities\screens\amenities_screen.dart",
    "d:\ap\p2\OceanView-Resort\frontend\lib\features\user\contact\screens\contact_screen.dart",
    "d:\ap\p2\OceanView-Resort\frontend\lib\features\user\experiences\screens\experiences_screen.dart",
    "d:\ap\p2\OceanView-Resort\frontend\lib\features\user\offers\screens\offers_screen.dart",
    "d:\ap\p2\OceanView-Resort\frontend\lib\features\user\rooms\screens\rooms_screen.dart"
)
foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        $fixed = $content -replace 'AppColors\.darkBgTertiary', 'AppColors.darkBgSecondary'
        Set-Content $file -Value $fixed -NoNewline
        Write-Host "Fixed: $file"
    } else {
        Write-Host "Not found: $file"
    }
}
Write-Host "Done."
