#!/bin/bash

# Validacion del usuario ejecutando el script
R_USER=$(id -u)
if [ "$R_USER" -ne 0 ]; then
    echo -e "\nDebe ejecutar este script como root o utilizando sudo.\n"
    exit 1
fi

pkill packagekitd
systemctl stop packagekit
systemctl mask packagekit
zypper up -y

sudo zypper ar -cfp 90 'https://ftp.fau.de/packman/suse/openSUSE_Leap_$releasever/' packman

rpm --import https://packages.microsoft.com/keys/microsoft.asc
zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode

rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
zypper addrepo https://brave-browser-rpm-release.s3.brave.com/x86_64/ brave-browser

zypper addrepo https://download.opensuse.org/repositories/home:Dead_Mozay/15.5/home:Dead_Mozay.repo

zypper addrepo https://yum.corretto.aws/corretto.repo
zypper refresh

zypper dup --from packman --allow-vendor-change

# Nix Package Manager
sh <(curl -L https://nixos.org/nix/install) --daemon

reboot