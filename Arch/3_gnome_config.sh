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

############################################# Tema WhiteSur #################################################################################
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
cd WhiteSur-gtk-theme || return
./install.sh -l -i fedora -N glassy
./tweaks.sh -f
sudo ./tweaks.sh -g -b "/usr/share/backgrounds/wallpapers/Landscapes/landscapes 01.jpg"
cd ..

git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
cd WhiteSur-icon-theme || return
./install.sh -t grey
cd ..

git clone https://github.com/vinceliuice/WhiteSur-cursors.git
cd WhiteSur-cursors || return
./install.sh
cd ..

rm -rf WhiteSur-gtk-theme
rm -rf WhiteSur-icon-theme
rm -rf WhiteSur-cursors
#############################################################################################################################################

# Tema Ulauncher
mkdir -p ~/.config/ulauncher/user-themes
git clone https://github.com/Raayib/WhiteSur-Dark-ulauncher.git ~/.config/ulauncher/user-themes/WhiteSur-Dark-ulauncher


############################################## Extensiones ##################################################################################
# Activar extensiones
dconf write /org/gnome/shell/enabled-extensions "['background-logo@fedorahosted.org', 'user-theme@gnome-shell-extensions.gcampax.github.com', 'arcmenu@arcmenu.com', 'drive-menu@gnome-shell-extensions.gcampax.github.com', 'Vitals@CoreCoding.com', 'systemd-manager@hardpixel.eu', 'tiling-assistant@leleat-on-github', 'blur-my-shell@aunetx', 'no-overview@fthx', 'pop-shell@system76.com', 'dash-to-dock@micxgx.gmail.com', 'caffeine@patapon.info', 'widgets@aylur']"
dconf write /org/gnome/shell/disabled-extensions "['dash-to-panel@jderose9.github.com']"

# ArcMenu
dconf write /org/gnome/shell/extensions/arcmenu/available-placement "[true, false, false]"
dconf write /org/gnome/mutter/overlay-key "'Super_R'"
dconf write /org/gnome/shell/extensions/arcmenu/pinned-app-list "['Web', '', 'org.gnome.Epiphany.desktop', 'Terminal', '', 'orggnome.Terminal. desktop', 'ArcMenu Settings', 'ArcMenu_ArcMenuIcon', 'gnome-extensions prefs arcmenu@arcmenu.com']"
dconf write /org/gnome/shell/extensions/arcmenu/menu-hotkey "'Undefined'"
dconf write /org/gnome/desktop/wm/keybindings/panel-main-menu "['Super_L']"
dconf write /org/gnome/shell/extensions/arcmenu/menu-button-icon "'Distro_Icon'"
dconf write /org/gnome/shell/extensions/arcmenu/distro-icon 2

# Logo
dconf write /org/fedorahosted/background-logo-extension/logo-always-visible true

# Tiling Assistant 
dconf write /org/gnome/mutter/edge-tiling false
dconf write /org/gnome/shell/overrides/edge-tiling false
dconf write /com/github/repsac-by/quake-mode/quake-mode-tray false

# Pop Shell
dconf write /org/gnome/shell/extensions/pop-shell/tile-by-default false
dconf write /org/gnome/shell/extensions/pop-shell/gap-inner 'uint32 1'
dconf write /org/gnome/shell/extensions/pop-shell/gap-outer 'uint32 1'
dconf write /org/gnome/shell/extensions/pop-shell/hint-color-rgba "'rgb(170,170,170)'"
dconf write /org/gnome/shell/extensions/pop-shell/active-hint false

# Dash to dock
dconf write /org/gnome/shell/extensions/dash-to-dock/dash-max-icon-size 32
dconf write /org/gnome/shell/extensions/dash-to-dock/show-apps-at-top true
dconf write /org/gnome/shell/extensions/dash-to-dock/apply-custom-theme true
dconf write /org/gnome/shell/extensions/blur-my-shell/dash-to-dock/blur false

# Aylur Widgets
dconf write /org/gnome/shell/extensions/aylurs-widgets/dash-links-names "['reddit', 'youtube', 'gmail', 'twitter', 'github']"
dconf write /org/gnome/shell/extensions/aylurs-widgets/dash-links-urls "['https://www.reddit.com/', 'https://www.youtube.com/', 'https://www.gmail.com/', 'https://twitter.com/', 'https://www.github.com/']"
dconf write /org/gnome/shell/extensions/aylurs-widgets/battery-bar false
dconf write /org/gnome/shell/extensions/aylurs-widgets/date-menu-tweaks false
dconf write /org/gnome/shell/extensions/aylurs-widgets/media-player false
dconf write /org/gnome/shell/extensions/aylurs-widgets/power-menu false
dconf write /org/gnome/shell/extensions/aylurs-widgets/workspace-indicator false
dconf write /org/gnome/shell/extensions/aylurs-widgets/background-clock-x-offset 50
dconf write /org/gnome/shell/extensions/aylurs-widgets/background-clock-y-offset 115
dconf write /org/gnome/shell/extensions/aylurs-widgets/background-clock-date-format "'%A %'"
dconf write /org/gnome/shell/extensions/aylurs-widgets/background-clock-date-format "'%A %d'"
dconf write /org/gnome/shell/extensions/aylurs-widgets/background-clock-date-size 46
dconf write /org/gnome/shell/extensions/aylurs-widgets/dash-button-position 2
dconf write /org/gnome/shell/extensions/aylurs-widgets/notification-indicator-position 2

dconf write /org/gnome/shell/disable-user-extensions false
#############################################################################################################################################
# Teclado
#dconf write /org/gnome/desktop/input-sources/sources "[('xkb', 'es+winkeys')]"

# Ventanas
dconf write /org/gnome/desktop/wm/preferences/button-layout "'appmenu:minimize,maximize,close'"
dconf write /org/gnome/mutter/center-new-windows true

# Tema
dconf write /org/gnome/desktop/interface/gtk-theme "'WhiteSur-Dark'"
dconf write /org/gnome/shell/extensions/user-theme/name "'WhiteSur-Dark'"
dconf write /org/gnome/desktop/interface/cursor-theme "'WhiteSur-cursors'"
dconf write /org/gnome/desktop/interface/icon-theme "'WhiteSur-grey-dark'"

# Wallpaper
dconf write /org/gnome/desktop/background/picture-uri "'file:///usr/share/backgrounds/wallpapers/Landscapes/landscapes%2001.jpg'"

# Establecer fuentes
dconf write /org/gnome/desktop/interface/font-name "'Noto Sans CJK HK 11'"
dconf write /org/gnome/desktop/interface/document-font-name "'Noto Sans CJK HK 11'"
dconf write /org/gnome/desktop/interface/monospace-font-name "'JetBrainsMono Nerd Font 12'"
dconf write /org/gnome/desktop/wm/preferences/titlebar-font "'Noto Sans CJK HK Bold 11'"

# Aplicaciones favoritas
dconf write /org/gnome/shell/favorite-apps "['thunar.desktop', 'kitty.desktop', 'virt-manager.desktop', 'mozilla-thunderbird.desktop', 'org.gabmus.gfeeds.desktop', 'qalculate-gtk.desktop', 'libreoffice-calc.desktop', 'code.desktop', 'google-chrome.desktop', 'firefox.desktop', 'brave-browser.desktop', 'org.qbittorrent.qBittorrent.desktop']"

# Nautilus
dconf write /org/gnome/nautilus/icon-view/default-zoom-level "'small'"
# Suspender
# En 2 horas enchufado
dconf write /org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-timeout 7200
# En 30 minutos con bateria
dconf write /org/gnome/settings-daemon/plugins/power/sleep-inactive-battery-timeout 1800

# Ulauncher
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/binding "'<Control>space'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/command "'ulauncher-toggle'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/name "'Ulauncher'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
#############################################################################################################################################

#############################################################################################################################################
flatpak --user override --filesystem="$HOME"/.themes
flatpak --user override --env=GTK_THEME=WhiteSur-Dark
#############################################################################################################################################

{
    echo 'menu_margin_x        = 10'
    echo 'menu_margin_y        = 480'
} >>~/.config/jgmenu/jgmenurc

sleep 5

reboot