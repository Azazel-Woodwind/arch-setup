#!/usr/bin/env bash

echo "en_GB.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen
sudo locale-gen

sudo pacman -Syu
sudo pacman -S --needed reflector
sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist
sudo pacman -S --needed - < pacman-packages.txt
rustup default stable
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..

sudo paru -S --needed - < paru-packages.txt
curl -fsSL https://bun.sh/install | bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

mkdir -p ~/.config/fish
cp -r fish ~/.config/
cp .tmux.conf ~/
cp starship.toml ~/.config/
cp .bashrc ~/
sudo cp .bash_profile /root
chsh -s /usr/bin/fish
sudo fish -c 'fish_add_path ~/.pyenv/bin'