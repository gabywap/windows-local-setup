# windows-local-setup

Ez a projekt egy `autounattend.xml` fájlt tartalmaz, amely lehetővé teszi a Windows 10 és Windows 11 telepítését:

- Manuális partícionálás (nem automatikus)
- Helyi felhasználó létrehozás (nem Microsoft fiók)
- Telepítés végén automatikusan futtat egy PowerShell szkriptet (programtelepítéshez)
- TPM és Secure Boot követelményeket kijátssza (Windows 11 régi gépen is)

## Projekt struktúra

```
windows-local-setup/
├── autounattend.xml
├── Setup/
│   └── Install-Apps.ps1
├── Sources/
│   └── $OEM$/
│       └── $$/
│           └── Setup/
│               └── Scripts/
│                   └── SetupComplete.cmd
└── README.md
```

## Telepítés lépései

1. Készíts egy Windows telepítő USB-t a hivatalos [Media Creation Tool](https://www.microsoft.com/software-download/windows10) vagy [Windows 11](https://www.microsoft.com/software-download/windows11) segítségével.
2. Másold a `autounattend.xml` fájlt a telepítő USB gyökerébe.
3. Másold a `Setup` mappát (benne az `Install-Apps.ps1`-vel) az USB-re.
4. Másold a `Sources\$OEM$\$$\Setup\Scripts\SetupComplete.cmd` fájlt is a megfelelő helyre a telepítőn belül (ezt a gyakorlatban a telepítő mappában kell elhelyezni).
5. Indítsd el a telepítést az USB-ről.
6. A partíciózást manuálisan végezd el a telepítő felületén.
7. A helyi felhasználó nevet add meg (nem Microsoft fiók).
8. A telepítés végén automatikusan lefut az `Install-Apps.ps1` szkript.

## Példa `Install-Apps.ps1` szkript

```powershell
# Példa alkalmazás telepítések winget-tel

Write-Output "Telepítés elkezdődött..."

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Output "winget nem található, ellenőrizd a telepítést!"
} else {
    winget install --id=VideoLAN.VLC -e --silent
    winget install --id=7zip.7zip -e --silent
    winget install --id=Notepad++.Notepad++ -e --silent
}

Write-Output "Telepítés befejezve."
```

## Licenc

MIT
