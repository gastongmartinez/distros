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
zypper dup -y

zypper ar -cfp 90 https://ftp.fau.de/packman/suse/openSUSE_Tumbleweed/ packman

rpm --import https://packages.microsoft.com/keys/microsoft.asc
zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode

rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
zypper addrepo https://brave-browser-rpm-release.s3.brave.com/x86_64/ brave-browser

zypper addrepo https://yum.corretto.aws/corretto.repo

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub > linux_signing_key.pub
rpm --import linux_signing_key.pub
zypper addrepo http://dl.google.com/linux/chrome/rpm/stable/x86_64 Google-Chrome

zypper addrepo https://download.opensuse.org/repositories/home:Dead_Mozay/openSUSE_Tumbleweed/home:Dead_Mozay.repo

zypper addrepo https://download.opensuse.org/repositories/shells:zsh-users:zsh-autosuggestions/openSUSE_Tumbleweed/shells:zsh-users:zsh-autosuggestions.repo

zypper addrepo https://download.opensuse.org/repositories/shells:zsh-users:zsh-syntax-highlighting/openSUSE_Tumbleweed/shells:zsh-users:zsh-syntax-highlighting.repo

zypper addrepo https://download.opensuse.org/repositories/home:Dead_Mozay/openSUSE_Tumbleweed/home:Dead_Mozay.repo

zypper refresh

zypper dup --from packman --allow-vendor-change -y

rm linux_signing_key.pub

# Nix Package Manager
sh <(curl -L https://nixos.org/nix/install) --daemon

reboot