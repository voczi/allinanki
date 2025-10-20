#Requires -Version 3.0

$ErrorActionPreference = "Stop"

if ($IsMacOS) {
    Write-Error "Please use the MacOS distribution to install Anki."
}
elseif ($IsLinux) {
    Write-Error "Please use the Linux distribution to install Anki."
}

$install_dir = Join-Path (Resolve-Path -Path $env:LOCALAPPDATA) "\Programs\Anki"
$exe_path = "$install_dir\Anki.exe"
$shortcut_path = Join-Path (Resolve-Path -Path $env:APPDATA) "\Microsoft\Windows\Start Menu\Programs\Anki.lnk"
$program_guid = "{975D2B51-55F1-40F7-A391-B14FA0038BDF}"
$uninstaller_root = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall\$program_guid"
$assocfile_root = "HKEY_CURRENT_USER\Software\Classes"

if (Test-Path -Path Registry::$uninstaller_root) {
    $uninstaller_path = (Get-ItemProperty -Path Registry::$uninstaller_root -Name "UninstallString").UninstallString
    Write-Host "An installation of Anki already exists on this system. To continue the old Anki installation has to be removed."
    $reply = Read-Host "Do you wish to continue? (y/n)"
    if ($reply -ne "Y") {
        Write-Error "Installation cancelled."
    }

    Write-Host "Waiting until the uninstaller is done.."
    & "$uninstaller_path"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Uninstallation of Anki failed."
    }
    Start-Sleep -Seconds 5
}

Write-Host "Anki will be installed to $install_dir"
Write-Host "Any files and folders under that path will be deleted."
$reply = Read-Host "Do you wish to continue? (y/n)"
if ($reply -ne "Y") {
    Write-Error "Installation cancelled."
}

Write-Host "Installing Anki.."
Remove-Item -Recurse -Force $install_dir -ErrorAction SilentlyContinue
New-Item -Path $install_dir -ItemType "Directory" -Force > $null
Copy-Item -Path * -Destination $install_dir -Recurse
Remove-Item -Path "$install_dir\install.bat", "$install_dir\scripts\Install.ps1"

$shortcut_creator_path = "$install_dir\scripts\create-shortcut.exe"
& $shortcut_creator_path $exe_path $shortcut_path $install_dir "Ankitects.Anki"
if ($LASTEXITCODE -ne 0) {
    Write-Error "Installation of Anki failed."
}
Remove-Item -Path $shortcut_creator_path

function Register-Assoc {
    param (
        [System.String] $FileExtension,
        [System.String] $Description
    )
    $ext_root = "$assocfile_root\.$FileExtension"
    New-Item -Path Registry::$ext_root -Value $Description -Force > $null
    New-ItemProperty -Path Registry::$ext_root -Name "FriendlyTypeName" -Value $Description > $null
    New-Item -Path Registry::"$ext_root\DefaultIcon" -Value "$exe_path,0" > $null
    New-Item -Path Registry::"$ext_root\shell\open\command" -Value "$exe_path ""%1""" -Force > $null
}

Register-Assoc "apkg" "Anki deck package"
Register-Assoc "colpkg" "Anki collection package"
Register-Assoc "ankiaddon" "Anki add-on"

$current_date = Get-Date -Format "yyyyMMdd"
$uninstaller_path = "$install_dir\uninstall.bat"
Move-Item -Path "$install_dir\scripts\uninstall.bat" -Destination $uninstaller_path
New-Item -Path Registry::$uninstaller_root -Force > $null
New-ItemProperty -Path Registry::$uninstaller_root -Name "DisplayIcon" -Value $exe_path > $null
New-ItemProperty -Path Registry::$uninstaller_root -Name "DisplayName" -Value "Anki" > $null
New-ItemProperty -Path Registry::$uninstaller_root -Name "HelpLink" -Value "https://github.com/voczi/allinanki" > $null
New-ItemProperty -Path Registry::$uninstaller_root -Name "InstallDate" -Value $current_date > $null
New-ItemProperty -Path Registry::$uninstaller_root -Name "InstallLocation" -Value $install_dir > $null
New-ItemProperty -Path Registry::$uninstaller_root -Name "NoModify" -Value 1 > $null
New-ItemProperty -Path Registry::$uninstaller_root -Name "NoRepair" -Value 1 > $null
New-ItemProperty -Path Registry::$uninstaller_root -Name "Publisher" -Value "Voczi" > $null
New-ItemProperty -Path Registry::$uninstaller_root -Name "UninstallString" -Value $uninstaller_path > $null

Write-Host "Done installing Anki!"
Write-Host "You are free to remove the current folder now, if you wish."
