#!/bin/bash
if not [ -f "/usr/bin/paru" ]; then
    echo "paru is not installed; installing it for you!"
    git clone https://aur.archlinux.org/paru
    if not [ -d "./paru" ]; then
        echo "Failed to clone paru; something went wrong"
        exit
    fi;

    cd ./paru
    makepkg -si
    cd ..
    rm -rf ./paru
fi;

echo "Installing main packages with paru -Syu --needed - < ./driver"
                                    paru -Syu --needed - < ./driver
echo "Installing AUR packages with paru -Syu --needed - < ./external"
# TODO: pacman needs sudo, but paru complains about being run as root
                                   paru -Syu --needed - < ./external
