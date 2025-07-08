# FirstLogon.ps1 – első bejelentkezéskor fut le

# 1. Windows.old mappa törlése (ha lenne)
cmd.exe /c "rmdir C:\Windows.old /S /Q"

# 2. Install-Apps parancsikon másolása az asztalra
$shortcutSource = 'C:\Setup\Install-Apps - Install Software and More.lnk'
$desktopPath = [Environment]::GetFolderPath('Desktop')
$shortcutTarget = Join-Path -Path $desktopPath -ChildPath 'Install-Apps - Install Software and More.lnk'

if (Test-Path $shortcutSource) {
    Copy-Item -Path $shortcutSource -Destination $shortcutTarget -Force
    Write-Output "Parancsikon átmásolva az asztalra: $shortcutTarget"
} else {
    Write-Output "Nem található a parancsikon: $shortcutSource"
}

# 3. (Opcionálisan ide jöhet még több dolog, ha bővíteni akarod a jövőben)

# 4. Naplózás (nem kötelező)
$log = "$env:TEMP\FirstLogon.log"
"FirstLogon.ps1 lefutott: $(Get-Date)" | Out-File -FilePath $log -Append
