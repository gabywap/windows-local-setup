# Példa alkalmazás telepítések winget-tel

Write-Output "Telepítés elkezdődött..."

# Ha nincs winget, azt is jelezzük, de nem áll meg a szkript
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Output "winget nem található, ellenőrizd a telepítést!"
} else {
    winget install --id=VideoLAN.VLC -e --silent
    winget install --id=7zip.7zip -e --silent
    winget install --id=Notepad++.Notepad++ -e --silent
}

Write-Output "Telepítés befejezve."
