#!/usr/bin/env bash

# Validacion del usuario ejecutando el script
R_USER=$(id -u)
if [ "$R_USER" -ne 0 ]; then
    echo -e "\nDebe ejecutar este script como root o utilizando sudo.\n"
    exit 1
fi

export LANG=en_US.UTF-8

# EPEL
dnf config-manager --set-enabled crb
dnf install epel-release -y

# RPM Fusion
dnf install --nogpgcheck "https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm" -y
dnf install --nogpgcheck "https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm" -y

# VSCODE
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# Brave
sh -c 'echo -e "[brave-browser-rpm-release.s3.brave.com_x86_64_]\nname=created by dnf config-manager from https://brave-browser-rpm-release.s3.brave.com/x86_64/\nbaseurl=https://brave-browser-rpm-release.s3.brave.com/x86_64/\nenabled=1" > /etc/yum.repos.d/brave-browser-rpm-release.s3.brave.com_x86_64_.repo'
rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

# Librewolf
dnf config-manager --add-repo https://rpm.librewolf.net/librewolf-repo.repo

# Google Chrome
sh -c 'echo -e "[google-chrome]\nname=google-chrome\nbaseurl=https://dl.google.com/linux/chrome/rpm/stable/x86_64\nenabled=1\ngpgcheck=1\ngpgkey=https://dl.google.com/linux/linux_signing_key.pub" > /etc/yum.repos.d/google-chrome.repo'

# Configuracion DNF
{
    echo 'fastestmirror=1'
    echo 'max_parallel_downloads=10'
} >> /etc/dnf/dnf.conf
dnf update -y

# NIX
USUARIO=$(grep "1000" /etc/passwd | awk -F : '{ print $1 }')
su "$USUARIO" <<EOF
    sh <(curl -L https://nixos.org/nix/install) --no-daemon
EOF

reboot