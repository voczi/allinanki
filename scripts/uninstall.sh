#!/usr/bin/env bash

set -e
cd "$(dirname "$0")"

installs_dir=$HOME/.local/bin
shortcuts_dir=$HOME/.local/share/applications
mimes_dir=$HOME/.local/share/mime/packages
icons_dir=$HOME/.local/share/icons

install_dir=$installs_dir/Anki
icon_path=$icons_dir/anki.png
shortcut_path=$shortcuts_dir/anki.desktop
mime_path=$mimes_dir/anki.xml
uninstaller_path=$install_dir/uninstall.sh

if [ ! -f "$uninstaller_path" ]; then
    echo Anki is not installed.
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

echo Anki will be removed from this computer.
echo All files and folders stored inside the installation directory will be removed.
echo Any active instances of Anki will be forcefully closed. Make sure you save your work.
read -p "Do you wish to continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

echo Uninstalling Anki..
killall -wqg -9 Anki
rm -rf "$install_dir" "$icon_path" "$shortcut_path" "$mime_path"
update-desktop-database "$shortcuts_dir"
update-mime-database "$mimes_dir/.." > /dev/null 2>&1

echo Anki has been uninstalled from your computer!
read -p "Press enter to exit the script."