#!/bin/bash
if not [ -f "/usr/bin/yay" ]; then
    echo "yay is not installed; installing it for you!"
    git clone https://aur.archlinux.org/yay
    if not [ -d "./yay" ]; then
        echo "Failed to clone yay; something went wrong"
        exit
    fi;

    cd ./yay
    makepkg -si
    cd ..
    rm -rf ./yay
fi;

echo "Installing main packages with pacman -Syu --needed - < ./driver"
                                    pacman -Syu --needed - < ./driver
echo "Installing AUR packages with yay -Syu --needed - < ./external"
# TODO: pacman needs sudo, but yay complains about being run as root
                                   yay -Syu --needed - < ./external
