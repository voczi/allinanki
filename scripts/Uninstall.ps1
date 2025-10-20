#Requires -Version 3.0

$ErrorActionPreference = "Stop"

$install_dir = Join-Path (Resolve-Path -Path $env:LOCALAPPDATA) "\Programs\Anki"
$exe_path = "$install_dir\Anki.exe"
$shortcut_path = Join-Path (Resolve-Path -Path $env:APPDATA) "\Microsoft\Windows\Start Menu\Programs\Anki.lnk"
$program_guid = "{975D2B51-55F1-40F7-A391-B14FA0038BDF}"
$uninstaller_root = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall\$program_guid"
$assocfile_root = "HKEY_CURRENT_USER\Software\Classes"

if (!(Test-Path -Path Registry::$uninstaller_root)) {
    Write-Error "Anki is not installed."
}

Write-Host "Anki will be removed from this computer."
Write-Host "All files and folders stored inside the installation directory will be removed."
Write-Host "Any active instances of Anki will be forcefully closed. Make sure you save your work."
$reply = Read-Host "Do you wish to continue? (y/n)"
if ($reply -ne "Y") {
    Write-Error "Installation cancelled."
}

Write-Host "Uninstalling Anki.."

if ((Get-Process "Anki" -ErrorAction SilentlyContinue).Count -gt 0) {
    Write-Host "Closing running Anki instance.."
    Stop-Process -Name "Anki" -Force
    Wait-Process -Name "Anki" -Timeout 10
    Start-Sleep -Seconds 5
}

function Unregister-Assoc {
    param (
        [System.String] $FileExtension
    )
    $ext_root = "$assocfile_root\.$FileExtension"
    Remove-Item -Path Registry::$ext_root -Recurse -Force -ErrorAction SilentlyContinue > $null
}

Unregister-Assoc "apkg"
Unregister-Assoc "colpkg"
Unregister-Assoc "ankiaddon"
Remove-Item -Force $shortcut_path
Remove-Item -Recurse -Force "_internal", "Anki.exe"
Remove-Item -Path Registry::$uninstaller_root -Recurse -Force > $null

Write-Host "Anki has been uninstalled from your computer!"