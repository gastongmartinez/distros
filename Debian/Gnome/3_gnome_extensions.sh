#!/usr/bin/env bash

R_USER=$(id -u)
if [ "$R_USER" -eq 0 ];
then
   echo "Este script debe usarse con un usuario regular."
   echo "Saliendo..."
   exit 1
fi

if [ -z "$DISPLAY" ];
then
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

# Vitals
git clone https://github.com/corecoding/Vitals.git ~/.local/share/gnome-shell/extensions/Vitals@CoreCoding.com

# Systemd Manager
git clone https://github.com/hardpixel/systemd-manager.git
cd systemd-manager || return
mv ./systemd-manager@hardpixel.eu ~/.local/share/gnome-shell/extensions/systemd-manager@hardpixel.eu
cd "$DIRE" || return
rm -rf systemd-manager

# Removable Drive
git clone https://gitlab.gnome.org/GNOME/gnome-shell-extensions.git
cd gnome-shell-extensions || return
git checkout gnome-43
meson build
ninja -C build install
cd "$DIRE" || return
rm -rf gnome-shell-extensions

# Blur my shell
git clone https://github.com/aunetx/blur-my-shell
cd blur-my-shell || return
make install
cd "$DIRE" || return
rm -rf blur-my-shell

# No Overview
git clone https://github.com/fthx/no-overview.git
mv no-overview ~/.local/share/gnome-shell/extensions/no-overview@fthx

# Aylur widgets
git clone https://github.com/Aylur/gnome-extensions.git
cd gnome-extensions || return
mv ./widgets@aylur ~/.local/share/gnome-shell/extensions/widgets@aylur
cd "$DIRE" || return
rm -rf gnome-extensions

flatpak --user install flathub com.mattjakeman.ExtensionManager -y

sleep 2

reboot