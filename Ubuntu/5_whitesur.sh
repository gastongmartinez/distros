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

############################################# Tema WhiteSur #################################################################################
pkill firefox
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git --depth=1
cd WhiteSur-gtk-theme || return
./install.sh -l -N glassy -t grey --shell -i ubuntu
./tweaks.sh -f
./tweaks.sh -F
sudo ./tweaks.sh -g -b "/usr/share/backgrounds/wallpapers/Landscapes/landscapes 01.jpg"
sudo flatpak override --filesystem=xdg-config/gtk-4.0
if [ ! -d ~/.themes ]; then
    mkdir -p ~/.themes
    tar -xf ./release/WhiteSur-Dark.tar.xz -C ~/.themes/
fi
cd ..

git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
cd WhiteSur-icon-theme || return
./install.sh -t grey
cd ..

git clone https://github.com/vinceliuice/WhiteSur-cursors.git
cd WhiteSur-cursors || return
./install.sh
cd ..

rm -rf WhiteSur-icon-theme
rm -rf WhiteSur-cursors
#############################################################################################################################################
# Tema
dconf write /org/gnome/shell/enabled-extensions "['arcmenu@arcmenu.com', 'blur-my-shell@aunetx', 'caffeine@patapon.info', 'systemd-manager@hardpixel.eu', 'Vitals@CoreCoding.com', 'drive-menu@gnome-shell-extensions.gcampax.github.com', 'ubuntu-dock@ubuntu.com', 'tiling-assistant@ubuntu.com', 'no-overview@fthx', 'user-theme@gnome-shell-extensions.gcampax.github.com']"
dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
dconf write /org/gnome/desktop/interface/gtk-theme "'WhiteSur-Dark'"
dconf write /org/gnome/shell/extensions/user-theme/name "'WhiteSur-Dark'"
dconf write /org/gnome/desktop/interface/cursor-theme "'WhiteSur-cursors'"
dconf write /org/gnome/desktop/interface/icon-theme "'WhiteSur-grey'"

# Wallpaper
# dconf write /org/gnome/desktop/background/picture-uri "'file:///usr/share/backgrounds/wallpapers/Landscapes/landscapes%2001.jpg'"
# dconf write /org/gnome/desktop/background/picture-uri-dark "'file:///usr/share/backgrounds/wallpapers/Landscapes/landscapes%2001.jpg'"

# Establecer fuentes
# dconf write /org/gnome/desktop/interface/font-name "'Noto Sans CJK HK 11'"
# dconf write /org/gnome/desktop/interface/document-font-name "'Noto Sans CJK HK 11'"
# dconf write /org/gnome/desktop/interface/monospace-font-name "'JetBrainsMono Nerd Font 12'"
# dconf write /org/gnome/desktop/wm/preferences/titlebar-font "'Noto Sans CJK HK Bold 11'"
#############################################################################################################################################

sleep 5

reboot