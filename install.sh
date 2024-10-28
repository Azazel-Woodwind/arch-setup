#!/usr/bin/env bash

sudo pacman -Syu
sudo pacman -S --needed reflector
sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist
sudo pacman -S --needed - < packages.txt
sudo paru -S --needed - < paru-packages.txt

curl -fsSL https://bun.sh/install | bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

cp -r fish ~/.config/
cp .tmux.conf ~/
cp starship.toml ~/.config/
cp .bashrc ~/
cp .bash_profile /root

chsh -s /usr/bin/fish
fish -c 'fish_add_path ~/.pyenv/bin'