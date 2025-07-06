# Windows 11 automatikus telepítés helyi fiókkal, manuális partícionálás nélkül

Ez a repository egy **automatikus Windows 11 telepítéshez** használható `autounattend.xml` fájlt és PowerShell szkripteket tartalmaz, amelyekkel a telepítés teljesen automatizált, magyar nyelvű, és **helyi fiókot** hoz létre Microsoft-fiók nélkül.

## Főbb funkciók

- Magyar nyelvű telepítés és felhasználói felület
- TPM, Secure Boot és egyéb hardverkövetelmények megkerülése (pl. régebbi gépeken is működik)
- Manuális partícionálás helyett automatikus partíciószerkezet létrehozása
- Helyi felhasználói fiók létrehozása jelszóval, Microsoft fiók nélkül
- Nem kívánt alapértelmezett Windows alkalmazások eltávolítása a telepítés után
- Automatikus PowerShell szkriptek futtatása az első bejelentkezéskor a rendszer testreszabásához
- Időzóna, billentyűzet és lokalizáció automatikus beállítása magyar nyelvre
- OOBE (Out-Of-Box Experience) gyorsított, egyszerűsített folyamata

---

## Tartalom

- `autounattend.xml`: az automatikus telepítést vezérlő XML fájl
- `Setup\Scripts\RemovePackages.ps1`: nem kívánt Windows alkalmazások eltávolítása
- `Setup\Scripts\RemoveCapabilities.ps1`: felesleges képességek eltávolítása
- `Setup\Scripts\SetStartPins.ps1`: Start menü alaphelyzetbe állítása
- `Setup\Scripts\Specialize.ps1`: fő beállítások futtatása a telepítés közben
- `Setup\Scripts\DefaultUser.ps1`: helyi felhasználói fiók létrehozása és jogosultságok beállítása
- `Setup\Scripts\FirstLogon.ps1`: első bejelentkezéskor futó szkript további beállításokhoz vagy programtelepítéshez
- `Setup\Scripts\Install-Apps.ps1`: opcionális további programok telepítését végző szkript (pl. winget, chocolatey)

---

## Hogyan használd?

1. Csomagold ki a repository tartalmát egy USB meghajtóra.

2. Másold az `autounattend.xml` fájlt az USB meghajtó gyökerébe.

3. Győződj meg róla, hogy a `Setup\Scripts` mappa a megfelelő PowerShell szkriptekkel a USB meghajtón is megtalálható.

4. Indítsd el a számítógépet az USB meghajtóról.

5. A telepítés automatikusan elindul, a partíciók létrejönnek, a helyi fiók létrejön, az OOBE lépések el lesznek hagyva, és a megadott szkriptek lefutnak.

6. Az első bejelentkezéskor a rendszer további testreszabások és programtelepítések indulnak el automatikusan.

---

## Fontos megjegyzések

- A helyi fiók neve és jelszava a `Setup\Scripts\DefaultUser.ps1` fájlban van beállítva. Itt módosíthatod saját igényeid szerint.

- A TPM és Secure Boot ellenőrzéseinek megkerülése nem garantálja a Microsoft támogatását, használd saját felelősségre!

- A nem kívánt alkalmazások és képességek eltávolítása a `RemovePackages.ps1` és `RemoveCapabilities.ps1` szkriptekben testreszabható.

- Az `Install-Apps.ps1` szkriptbe teheted bele azokat a programokat, amelyeket a telepítés után automatikusan szeretnél telepíteni (például winget parancsok).

- A telepítés nyelve és billentyűzet kiosztása magyarra van állítva, ezt az `autounattend.xml` fájlban tudod módosítani.

---

## autounattend.xml főbb részei magyarázattal

- **windowsPE pass**: telepítő nyelvének, billentyűzetének és alapbeállításainak megadása; TPM/SecureBoot megkerülő registry beállítások.

- **specialize pass**: helyi fiók létrehozása, rendszeridőzóna beállítása, egyedi PowerShell szkriptek futtatása.

- **oobeSystem pass**: OOBE folyamat egyszerűsítése, Microsoft fiók kérésének eltávolítása, első bejelentkezéskor futó szkriptek.

- **Extensions rész**: a telepítés során futtatandó PowerShell szkriptek definiálása.

---

## Példa helyi fiók beállítása a DefaultUser.ps1-ben

```powershell
$UserName = 'LokálisFelhasználó'
$Password = 'Jelszo123!' | ConvertTo-SecureString -AsPlainText -Force
New-LocalUser -Name $UserName -Password $Password -FullName 'Lokális Felhasználó' -Description 'Helyi fiók a telepítés után' -AccountNeverExpires
Add-LocalGroupMember -Group 'Administrators' -Member $UserName
Remove-LocalUser -Name 'Administrator' # opcionális, ha az alapértelmezett admin nem kell

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
# 🪟 Windows Local Setup (Windows 11/10)

Ez a projekt egy teljesen **automatikus, testreszabott Windows 10 / 11 telepítést** tesz lehetővé `autounattend.xml` segítségével. A rendszer telepítése közben PowerShell szkriptek futnak le, melyek eltávolítanak felesleges alkalmazásokat, engedélyeznek hasznos beállításokat, és helyi felhasználót használnak Microsoft-fiók helyett.

---

## 📁 Fájlstruktúra

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

---

## ⚙️ Funkciók

- 🇭🇺 Telepítés magyar nyelven
- 💻 Helyi felhasználói fiók létrehozása, Microsoft-fiók kihagyása
- 💣 Alkalmazások eltávolítása (Xbox, Bing, Skype, OneDrive, stb.)
- 🔐 TPM, Secure Boot, RAM minimum megkerülése (Windows 11 esetén)
- 🧠 SmartScreen, Bing keresés, telemetria kikapcsolása
- 🧩 Start menü és tálca testreszabása
- 🖥️ Távoli asztal engedélyezése
- 🧪 PowerShell szkriptek automatikus futtatása
- 📦 `C:\Windows.old` eltávolítása
- 📁 Látható Asztal ikonok (Sajátgép, Lomtár, stb.)

---

## 🧰 Rendszerkövetelmények

- Windows 10 vagy Windows 11 ISO (bármilyen kiadás)
- Rufus vagy más eszköz a bootolható pendrive-hoz
- Min. 8 GB USB meghajtó

---

## 🛠️ Használat

1. Töltsd le a repót:  
   [https://github.com/gabywap/windows-local-setup](https://github.com/gabywap/windows-local-setup)

2. Másold fel a fájlokat a pendrive-ra:

   - `autounattend.xml` → gyökérbe
   - `Sources\$OEM$\$$\Setup\Scripts\SetupComplete.cmd` → ISO `Sources` mappájába
   - `Setup\Install-Apps.ps1` → gyökér vagy más egyéni hely

3. Bootolj be az USB-ről, és indul a telepítés

---

## 💡 PowerShell szkriptek rövid leírása

- `Install-Apps.ps1`: Telepíti az általad megadott programokat (ha van ilyen listád)
- `SetupComplete.cmd`: A telepítés legvégén fut, itt hívódnak meg a PowerShell szkriptek
- `RemovePackages.ps1`: Xbox, Skype, Bing, OneDrive stb. eltávolítása
- `RemoveCapabilities.ps1`: Fax, Hello Face, Steps Recorder eltávolítása
- `Specialize.ps1`: Frissítési korlátok megkerülése, SmartScreen és telemetria letiltása
- `UserOnce.ps1`: Felhasználói asztal ikonok, keresősáv beállítás
- `FirstLogon.ps1`: Telepítés utáni takarítás (pl. Windows.old törlés)

---

## 🧪 Extra lehetőségek

- Bővítheted `Install-Apps.ps1`-t pl. `winget` programlista alapján
- `SetupComplete.cmd` segítségével bármilyen parancs lefuttatható
- `autounattend.xml` bővíthető automatikus partícióval is (de most interaktívra van állítva)

---

## 🤝 Közreműködés

Szívesen veszek minden javaslatot, pull requestet vagy hibajelentést.

**GitHub:** [@gabywap](https://github.com/gabywap)

---

## 📝 Megjegyzés

Ez a rendszer célja, hogy egy minimalista, felesleges funkcióktól mentes, gyors Windows rendszert adjon, különösen Windows 11 esetén, ahol sok beépített korlátozást el kell kerülni.


Testreszabás
Felhasználónév és jelszó: módosítsd a DefaultUser.ps1 fájlban.

Eltávolítandó alkalmazások: a RemovePackages.ps1 fájlban testreszabható.

Telepítendő programok: Install-Apps.ps1 szkriptbe tehetők, például winget segítségével.

Időzóna, nyelv, billentyűzet: autounattend.xml fájlban módosítható.

Fontos megjegyzések
A TPM és Secure Boot megkerülése a registry módosításával nem hivatalos, és nem garantált, hogy minden gépen működik.

A telepítés során a Windows automatikusan elfogadja a licencfeltételeket.

A helyi fiók létrehozása Microsoft-fiók használata nélkül lehetséges.

Minden szkript futtatása PowerShellben történik, a végrehajtási házirend Bypass állapotban.

Közreműködés
Ha javítanál vagy fejlesztenél a projekten, kérlek hozz létre pull requestet vagy issue-t.

Licenc
Ez a projekt szabadon felhasználható és módosítható.

Kapcsolat
Készítette: Gabywap
Dátum: 2025.07.06
