#!/usr/bin/env bash

# Validacion del usuario ejecutando el script
R_USER=$(id -u)
if [ "$R_USER" -ne 0 ];then
    echo -e "\nSe debe ejecutar este script como root.\n"
    exit 1
fi
if [ "$LOGNAME" != "root" ]; then
    echo -e "\nEs necesario iniciar la sesión como root (su -).\n"
    exit 1
fi

USER=$(grep "1000" /etc/passwd | awk -F : '{ print $1 }')
usermod -aG sudo "$USER"

# Apt config
cp /etc/apt/sources.list /etc/apt/sources.list.ORIGINAL
sed -i "2d;/deb cdrom/d" "/etc/apt/sources.list"
sed -i "s/main/main contrib non-free/g" "/etc/apt/sources.list"
apt install apt-transport-https -y
apt install curl -y
apt install nala -y

# Ajuste Swappiness
echo -e "vm.swappiness=10\n" >> /etc/sysctl.d/90-sysctl.conf

# VSCODE Repo
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

# Brave
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources

# Librewolf
distro=$(if echo " una vanessa focal jammy bullseye vera uma" | grep -q " $(lsb_release -sc) "; then lsb_release -sc; else echo focal; fi)
wget -O- https://deb.librewolf.net/keyring.gpg | gpg --dearmor -o /usr/share/keyrings/librewolf.gpg
tee /etc/apt/sources.list.d/librewolf.sources << EOF > /dev/null
Types: deb
URIs: https://deb.librewolf.net
Suites: $distro
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/librewolf.gpg
EOF

# Google Chrome
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list

apt update

# Limpieza de paquetes
apt remove firefox-esr -y
apt remove libreoffice-base-core -y
apt remove libreoffice-common -y
apt remove libreoffice-style-colibre -y
apt autoremove -y


# Configuracion de servidores
nala fetch

# Nix
sh <(curl -L https://nixos.org/nix/install) --daemon