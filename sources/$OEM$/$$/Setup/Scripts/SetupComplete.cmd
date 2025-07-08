@echo off
powershell.exe -ExecutionPolicy Bypass -File "%SystemDrive%\Setup\FirstLogon.ps1"
echo SetupComplete.cmd lefutott: %DATE% %TIME% >> %TEMP%\setupcomplete2.log

exit
