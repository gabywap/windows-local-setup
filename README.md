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
