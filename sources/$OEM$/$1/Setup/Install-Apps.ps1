$apps = @(
    "Microsoft.DirectX",
    "IrfanSkiljan.IrfanView",
    "IrfanSkiljan.IrfanView.PlugIns",
    "Google.Chrome",
    "Daum.PotPlayer",
    "VideoLAN.VLC",
    "Opera.Opera",
    "Mozilla.Firefox.hu",
    "7zip.7zip",
    "Brave.Brave",
    "Ghisler.TotalCommander",
    "MathiasSvensson.MultiCommander",
    "Piriform.CCleaner",
    "Notepad++.Notepad++",
    "Winamp.Winamp",
    "AIMP.AIMP"
)

foreach ($app in $apps) {
    Write-Host "`n🔄 Telepítés: $app" -ForegroundColor Cyan
    try {
        winget install --id=$app -e --silent --accept-package-agreements --accept-source-agreements
    } catch {
        Write-Warning "⚠️ Hiba a(z) $app telepítése közben: $_"
    }
}
Write-Host "`n✅ Kész minden program telepítésével!" -ForegroundColor Green
