# Install-Apps.ps1
# Programok automatikus telepítése winget használatával

Write-Output "Telepítés elkezdődött..."

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Output "winget nem található, ellenőrizd a telepítést!"
    exit 1
}

# Telepítendő programok listája
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
    Write-Output "Telepítés: $app"
    winget install --id=$app -e --silent --accept-package-agreements --accept-source-agreements
}

Write-Output "Telepítés befejezve."

