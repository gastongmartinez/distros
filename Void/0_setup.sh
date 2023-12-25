#!/usr/bin/bash

# Validacion de usuario
R_USER=$(id -u)
if [ "$R_USER" -ne 0 ]; then
    echo -e "\nDebe ejecutar este script como root o utilizando sudo.\n"
    exit 1
fi

# Actualizacion
xbps-install -Suvy

# Agrega repo nonfree
xbps-install -Rs void-repo-nonfree --yes
xbps-install -Suvy

# Ajuste Swappiness
echo -e "vm.swappiness=10\n" >> /etc/sysctl.conf

# KDE
xbps-install -y xorg
xbps-install -y kde5
xbps-install -y sddm
xbps-install -y dbus
xbps-install -y konsole
xbps-install -y okular
xbps-install -y dolphin
xbps-install -y dolphin-plugins
xbps-install -y ark
xbps-install -y kate5
xbps-install -y spectacle
xbps-install -y kwallet
xbps-install -y kcalc
xbps-install -y kfind
xbps-install -y ksystemlog
xbps-install -y kcolorchooser
xbps-install -y filelight
xbps-install -y yakuake
xbps-install -y khelpcenter
xbps-install -y partitionmanager
xbps-install -y lokalize
xbps-install -y kolourpaint
xbps-install -y kcharselect
xbps-install -y krdc
xbps-install -y kompare
xbps-install -y kruler
xbps-install -y sweeper
xbps-install -y kamoso
xbps-install -y elisa
xbps-install -y kmag
xbps-install -y akregator
xbps-install -y kalarm
xbps-install -y ktouch
xbps-install -y knotes
xbps-install -y krusader
echo "setxkbmap es" >> /usr/share/sddm/scripts/Xsetup
if [ ! -d /etc/sddm.conf.d ]; then
    mkdir /etc/sddm.conf.d
fi
{
    echo '[Autologin]'
    echo 'Relogin=false'
    echo 'Session='
    echo 'User='
    echo ''
    echo '[General]'
    echo 'HaltCommand='
    echo 'RebootCommand='
    echo ''
    echo '[Theme]'
    echo 'Current=breeze'
    echo ''
    echo '[Users]'
    echo 'MaximumUid=60000'
    echo 'MinimumUid=1000'
} >>/etc/sddm.conf.d/kde_settings.conf
touch /etc/sddm.conf

# NetworkManager
xbps-install -y NetworkManager-openvpn 
xbps-install -y NetworkManager-openconnect
xbps-install -y NetworkManager-vpnc
xbps-install -y NetworkManager-l2tp

# XDG
xbps-install -y xdg-user-dirs
xbps-install -y xdg-user-dirs-gtk
xbps-install -y xdg-utils

# Logs
xbps-install -y socklog-void

# NTP
xbps-install -y chrony

# Firmware
xbps-install -y intel-ucode
xbps-install -y linux-firmware-amd

# initramfs
KVER=$(uname -a | awk -F '[ ]' '{ print $3 }' | awk -F '.' '{ print $1"."$2 }')
xbps-reconfigure -f "linux$KVER"

# Habilitacion de servicios
ln -s /etc/sv/dbus /var/service
ln -s /etc/sv/elogind /var/service
ln -s /etc/sv/NetworkManager /var/service
ln -s /etc/sv/sshd /var/service
ln -s /etc/sv/socklog-unix /var/service
ln -s /etc/sv/nanoklogd /var/service
ln -s /etc/sv/sddm /var/service
ln -s /etc/sv/chronyd /var/service

reboot