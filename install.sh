#!/usr/bin/env bash

sudo pacman -Syu
sudo pacman -S --needed reflector
sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist
sudo pacman -S --needed - < pacman-packages.txt
sudo paru -S --needed - < paru-packages.txt

sudo curl -fsSL https://bun.sh/install | bash
sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

sudo cp -r fish ~/.config/
sudo cp .tmux.conf ~/
sudo cp starship.toml ~/.config/
sudo cp .bashrc ~/
sudo cp .bash_profile /root

sudo chsh -s /usr/bin/fish
fish -c 'fish_add_path ~/.pyenv/bin'