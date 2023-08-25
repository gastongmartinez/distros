#!/usr/bin/env bash

R_USER=$(id -u)
if [ "$R_USER" -eq 0 ]; then
   echo "Este script debe usarse con un usuario regular."
   echo "Saliendo..."
   exit 1
fi

nix-env -iA nixpkgs.qtile
nix-env -iA nixpkgs.picom
nix-env -iA nixpkgs.lxappearance
nix-env -iA nixpkgs.jgmenu
nix-env -iA nixpkgs.i3lock-blur
nix-env -iA nixpkgs.sway
nix-env -iA nixpkgs.sway-contrib.grimshot
nix-env -iA nixpkgs.waybar
nix-env -iA nixpkgs.wofi
nix-env -iA nixpkgs.wlr-randr
nix-env -iA nixpkgs.wlogout
nix-env -iA nixpkgs.swaybg
nix-env -iA nixpkgs.swayimg
nix-env -iA nixpkgs.swaysome
nix-env -iA nixpkgs.swaylock
nix-env -iA nixpkgs.swayidle
nix-env -iA nixpkgs.swaytools
nix-env -iA nixpkgs.swaysettings
nix-env -iA nixpkgs.swaynotificationcenter
nix-env -iA nixpkgs.pavucontrol

{
    echo "[Desktop Entry]"
    echo "Name=Qtile"
    echo "Comment=Qtile Session"
    echo "Exec=$HOME/.nix-profile/bin/qtile start"
    echo "Type=Application"
    echo "Keywords=wm;tiling"
} >>~/qtile.desktop

{
    echo "[Desktop Entry]"
    echo "Name=Sway"
    echo "Comment=An i3-compatible Wayland compositor"
    echo "Exec=$HOME/.nix-profile/bin/sway"
    echo "Type=Application"
} >>~/sway.desktop

sudo mv ~/qtile.desktop /usr/share/xsessions/
sudo mv ~/sway.desktop /usr/share/wayland-sessions/