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
apt install extrepo -y
extrepo enable librewolf

# Google Chrome
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor | tee /etc/apt/trusted.gpg.d/google.gpg >/dev/null
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