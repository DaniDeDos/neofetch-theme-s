#!/usr/bin/env bash
#|---/ /+-------------------------------------------+---/ /|#
#|--/ /-| Script to install aur helper, yay or paru |--/ /-|#
#|-/ /--| Prasanth Rangan                           |-/ /--|#
#|/ /---+-------------------------------------------+/ /---|#

# shellcheck disable=SC1091
# shellcheck disable=SC2088
# shellcheck disable=SC2154
# shellcheck disable=SC2164
# shellcheck disable=SC2086
# shellcheck disable=SC2181

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/utils/global.sh"
if [ $? -ne 0 ]; then
    echo "Error: unable to source global.sh..."
    exit 1
fi

if chk_list "aurhlpr" "${aurList[@]}"; then
    echo -e "\033[0;32m[AUR]\033[0m detected // ${aurhlpr}"
    exit 0
fi

aurhlpr="${1:-yay}"

if [ -d "$HOME/repos/clone" ]; then
    echo "~/Clone directory exists..."
    rm -rf "$HOME/Clone/${aurhlpr}"
else
    mkdir "$HOME/repos/clone"
    echo -e "[Desktop Entry]\nIcon=default-folder-git" >"$HOME/repos/clone/.directory"
    echo "~/Clone directory created..."
fi

if pkg_installed git; then
    git clone "https://aur.archlinux.org/${aurhlpr}.git" "$HOME/repos/clone/${aurhlpr}"
else
    echo "git dependency is not installed..."
    exit 1
fi

cd "$HOME/repos/clone/${aurhlpr}"
makepkg ${use_default} -si

if [ $? -eq 0 ]; then
    echo "${aurhlpr} aur helper installed..."
    exit 0
else
    echo "${aurhlpr} installation failed..."
    exit 1
fi
