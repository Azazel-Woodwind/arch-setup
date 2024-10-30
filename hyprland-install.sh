#!/usr/bin/env fish

# Install Hyprland Dependencies
paru -S --needed - < packages/hyprland/deps.txt

# Install Hyprland
git clone --recursive https://github.com/hyprwm/Hyprland
cd Hyprland
make all && sudo make install

# Install packages
sudo pacman -S --needed - < packages/amd-drivers.txt
sudo pacman -S --needed - < packages/wayland/pacman.txt
paru -S --needed - < packages/wayland/paru.txt

systemctl --user start hyprland-session.service

# sudo systemctl enable sddm

# git clone https://github.com/danyspin97/wpaperd
# cd wpaperd
# cargo build --release
# rinstall --yes
