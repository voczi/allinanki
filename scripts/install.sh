#!/usr/bin/env bash

set -e
cd "$(dirname "$0")"

if [ "$(uname)" == "Darwin" ]; then
    echo Please use the MacOS distribution to install Anki.
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
elif [ "$(expr substr $(uname -s) 1 5)" == "MINGW" ]; then
    echo Please use the Windows distribution to install Anki.
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

installs_dir=$HOME/.local/bin
shortcuts_dir=$HOME/.local/share/applications
mimes_dir=$HOME/.local/share/mime/packages
icons_dir=$HOME/.local/share/icons

install_dir=$installs_dir/Anki
icon_path=$icons_dir/anki.png
shortcut_path=$shortcuts_dir/anki.desktop
mime_path=$mimes_dir/anki.xml
uninstaller_path=$install_dir/uninstall.sh

if [ -f "$uninstaller_path" ]; then
    echo An installation of Anki already exists on this system. To continue the old Anki installation has to be removed.
    read -p "Do you wish to continue? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
    fi

    echo Launching uninstaller.
    "$uninstaller_path"
fi

echo Anki will be installed to $install_dir
echo Any files and folders under that path will be deleted.
read -p "Do you wish to continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

echo Installing Anki...
rm -rf "$install_dir"
mkdir -p "$install_dir" "$shortcuts_dir" "$icons_dir" "$mimes_dir"
cp -r README.md LICENSE Anki _internal ./uninstall.sh "$install_dir"
cp ./resources/anki.xml "$mime_path"
update-mime-database "$mimes_dir/.." > /dev/null 2>&1
cp ./resources/anki.desktop "$shortcut_path"
sed -i -e "s|INSTALL_DIR|$install_dir|g" -e "s|ICON_PATH|$icon_path|g" "$shortcut_path"
update-desktop-database "$shortcuts_dir"
cp ./resources/anki.png "$icon_path"

echo Done installing Anki in "$install_dir"
echo You are free to remove the current folder now, if you wish.
read -p "Press enter to exit the script."