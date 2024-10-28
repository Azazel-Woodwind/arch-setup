#!/usr/bin/env fish

sudo pacman -Syu mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon libva-mesa-driver mesa-vdpau lib32-libva-mesa-driver lib32-mesa-vdpau qt6-wayland qt5ct libdecor

echo "
--enable-features=WebRTCPipeWireCapturer,WaylandWindowDecorations
--ozone-platform-hint=wayland
" > ~/.config/electron-flags.conf

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
" > ~/.bashrc

cp ~/.bashrc /root/.bashrc