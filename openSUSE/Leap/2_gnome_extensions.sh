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
git checkout gnome-40/41
make install
cd "$DIRE" || return
rm -rf ArcMenu

# Sound output chooser
git clone https://github.com/kgshank/gse-sound-output-device-chooser.git
cp -r gse-sound-output-device-chooser/sound-output-device-chooser@kgshank.net ~/.local/share/gnome-shell/extensions/
rm -rf "gse-sound-output-device-chooser"

# Tweaks in system menu
wget https://github.com/F-i-f/tweaks-system-menu/releases/download/v18/tweaks-system-menu@extensions.gnome-shell.fifi.org.v18.shell-extension.zip
gnome-extensions install tweaks-system-menu@extensions.gnome-shell.fifi.org.v18.shell-extension.zip
rm tweaks-system-menu@extensions.gnome-shell.fifi.org.v18.shell-extension.zip

# Dash to Dock
git clone https://github.com/micheleg/dash-to-dock.git
cd dash-to-dock || return
git checkout extensions.gnome.org-v82
make install
cd "$DIRE" || return
rm -rf dash-to-dock

# Vitals
git clone https://github.com/corecoding/Vitals.git ~/.local/share/gnome-shell/extensions/Vitals@CoreCoding.com

# Blur my shell
git clone https://github.com/aunetx/blur-my-shell
cd blur-my-shell || return
git checkout tags/v29
make install
cd "$DIRE" || return
rm -rf blur-my-shell

# Systemd Manager
git clone https://github.com/hardpixel/systemd-manager.git
cd systemd-manager || return
mv ./systemd-manager@hardpixel.eu ~/.local/share/gnome-shell/extensions/systemd-manager@hardpixel.eu
cd "$DIRE" || return
rm -rf systemd-manager

# Tiling assistant
git clone https://github.com/Leleat/Tiling-Assistant.git
cd Tiling-Assistant/scripts || return
git checkout tags/v32
chmod +x build.sh
./build.sh -i
cd "$DIRE" || return
rm -rf Tiling-Assistant

# Removable Drive
git clone https://gitlab.gnome.org/GNOME/gnome-shell-extensions.git
cd gnome-shell-extensions || return
meson build
ninja -C build install
cd "$DIRE" || return
rm -rf gnome-shell-extensions

# No Overview
git clone https://github.com/fthx/no-overview.git
mv no-overview ~/.local/share/gnome-shell/extensions/no-overview@fthx

# Caffeine
git clone https://github.com/eonpatapon/gnome-shell-extension-caffeine.git
cd gnome-shell-extension-caffeine || return
git checkout tags/v42
make build
make install
cd "$DIRE" || return
rm -rf gnome-shell-extension-caffeine

sleep 2

sudo reboot