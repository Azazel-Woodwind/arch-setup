#!/usr/bin/env fish

# Set up wayland environment variables
set -Ux ELECTRON_OZONE_PLATFORM_HINT "wayland"
set -Ux XDG_SESSION_TYPE wayland
set -Ux QT_QPA_PLATFORM wayland
set -Ux GDK_BACKEND wayland
set -Ux CLUTTER_BACKEND wayland
set -Ux QT_QPA_PLATFORMTHEME qt5ct
set -Ux CLUTTER_BACKEND wayland
set -Ux SDL_VIDEODRIVER "wayland,x11"

echo "
export ELECTRON_OZONE_PLATFORM_HINT="wayland"
export XDG_SESSION_TYPE="wayland"
export QT_QPA_PLATFORM="wayland"
export GDK_BACKEND="wayland"
export CLUTTER_BACKEND="wayland"
export QT_QPA_PLATFORMTHEME="qt5ct"
export SDL_VIDEODRIVER="wayland,x11"
" >> ~/.bashrc

sudo cp ~/.bashrc /root/.bashrc
cp config/electron-flags.conf ~/.config/
cp config/code-flags.conf ~/.config/
cp -r config/hypr ~/.config/