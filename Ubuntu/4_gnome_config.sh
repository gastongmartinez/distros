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

############################################## Extensiones ##################################################################################
# Activar extensiones
dconf write /org/gnome/shell/enabled-extensions "['arcmenu@arcmenu.com', 'blur-my-shell@aunetx', 'caffeine@patapon.info', 'systemd-manager@hardpixel.eu', 'Vitals@CoreCoding.com', 'drive-menu@gnome-shell-extensions.gcampax.github.com', 'ubuntu-dock@ubuntu.com', 'tiling-assistant@ubuntu.com', 'no-overview@fthx']"
dconf write /org/gnome/shell/disabled-extensions "['ding@rastersoft.com']"

# ArcMenu
dconf write /org/gnome/shell/extensions/arcmenu/available-placement "[true, false, false]"
dconf write /org/gnome/mutter/overlay-key "'Super_R'"
dconf write /org/gnome/shell/extensions/arcmenu/menu-hotkey "'Undefined'"
dconf write /org/gnome/desktop/wm/keybindings/panel-main-menu "['Super_L']"
dconf write /org/gnome/shell/extensions/arcmenu/menu-button-icon "'Distro_Icon'"
dconf write /org/gnome/shell/extensions/arcmenu/distro-icon 5

# Dash to dock
dconf write /org/gnome/shell/extensions/dash-to-dock/extend-height false
dconf write /org/gnome/shell/extensions/dash-to-dock/dash-max-icon-size 32
dconf write /org/gnome/shell/extensions/dash-to-dock/dock-position "'BOTTOM'"
dconf write /org/gnome/shell/extensions/dash-to-dock/show-trash false
dconf write /org/gnome/shell/extensions/dash-to-dock/dock-fixed false
dconf write /org/gnome/shell/extensions/dash-to-dock/intellihide-mode "'ALL_WINDOWS'"
dconf write /org/gnome/shell/extensions/dash-to-dock/autohide-in-fullscreen true
dconf write /org/gnome/shell/extensions/dash-to-dock/show-apps-at-top true
dconf write /org/gnome/shell/extensions/dash-to-dock/show-mounts-only-mounted true
dconf write /org/gnome/shell/extensions/dash-to-dock/show-mounts-network false
dconf write /org/gnome/shell/extensions/blur-my-shell/dash-to-dock/blur false

#############################################################################################################################################
# Establecer fuentes
dconf write /org/gnome/desktop/interface/monospace-font-name "'JetBrainsMono Nerd Font 12'"

# Color
dconf write /org/gnome/desktop/interface/accent-color "'blue'"
dconf write /org/gnome/desktop/interface/gtk-theme "'Yaru-blue-dark'"
dconf write /org/gnome/desktop/interface/icon-theme "'Yaru-blue-dark'"

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

sleep 5

reboot