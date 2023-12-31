#!/usr/bin/env bash

R_USER=$(id -u)
if [ "$R_USER" -eq 0 ]; then
   echo "Este script debe usarse con un usuario regular."
   echo "Saliendo..."
   exit 1
fi

if [ -z "$DISPLAY" ]; then
    echo -e "Debe ejecutarse dentro del entorno grafico.\n"
    echo "Saliendo..."
    exit 2
fi

DIRE=$(pwd)
# Arc Menu
git clone https://gitlab.com/arcmenu/ArcMenu.git
cd ArcMenu || return
make install
cd "$DIRE" || return
rm -rf ArcMenu

# Dash to Dock
git clone https://github.com/micheleg/dash-to-dock.git
make -C dash-to-dock install
rm -rf dash-to-dock

# Blur my shell
git clone https://github.com/aunetx/blur-my-shell
cd blur-my-shell || return
make install
cd "$DIRE" || return
rm -rf blur-my-shell

# No Overview
git clone https://github.com/fthx/no-overview.git
mv no-overview ~/.local/share/gnome-shell/extensions/no-overview@fthx

# Vitals
git clone https://github.com/corecoding/Vitals.git ~/.local/share/gnome-shell/extensions/Vitals@CoreCoding.com

# Systemd Manager
git clone https://github.com/hardpixel/systemd-manager.git
cd systemd-manager || return
mv ./systemd-manager@hardpixel.eu ~/.local/share/gnome-shell/extensions/systemd-manager@hardpixel.eu
cd "$DIRE" || return
rm -rf systemd-manager

# Tiling assistant
git clone https://github.com/Leleat/Tiling-Assistant.git
cd Tiling-Assistant/scripts || return
chmod +x build.sh
./build.sh -i
cd "$DIRE" || return
rm -rf Tiling-Assistant

# Aylur widgets
git clone https://github.com/Aylur/gnome-extensions.git
cd gnome-extensions || return
mv ./widgets@aylur ~/.local/share/gnome-shell/extensions/widgets@aylur
cd "$DIRE" || return
rm -rf gnome-extensions

# Caffeine
git clone https://github.com/eonpatapon/gnome-shell-extension-caffeine.git
cd gnome-shell-extension-caffeine || return
make build
make install
cd "$DIRE" || return
rm -rf gnome-shell-extension-caffeine

sleep 2

reboot