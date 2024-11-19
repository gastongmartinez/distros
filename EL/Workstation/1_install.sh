#!/usr/bin/env bash

# Validacion del usuario ejecutando el script
R_USER=$(id -u)
if [ "$R_USER" -ne 0 ]; then
    echo -e "\nDebe ejecutar este script como root o utilizando sudo.\n"
    exit 1
fi

systemctl enable sshd
export LANG=en_US.UTF-8

# Ajuste Swappiness
echo -e "vm.swappiness=10\n" >> /etc/sysctl.d/90-sysctl.conf

USER=$(grep "1000" /etc/passwd | awk -F : '{ print $1 }')

# Descarga de RPMs
wget https://corretto.aws/downloads/latest/amazon-corretto-17-x64-linux-jdk.rpm
wget https://archivefedora.mirror.angkasa.id/fedora/linux/releases/34/Everything/x86_64/os/Packages/t/terminus-fonts-4.49.1-12.fc34.noarch.rpm
wget https://archivefedora.mirror.angkasa.id/fedora/linux/releases/34/Everything/x86_64/os/Packages/c/cascadia-code-fonts-2102.25-1.fc34.noarch.rpm
wget https://archivefedora.mirror.angkasa.id/fedora/linux/releases/34/Everything/x86_64/os/Packages/f/fira-code-fonts-5.2-3.fc34.noarch.rpm
wget https://archivefedora.mirror.angkasa.id/fedora/linux/releases/34/Everything/x86_64/os/Packages/x/xorg-x11-font-utils-7.5-51.fc34.x86_64.rpm
wget https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

############################### Apps Generales ################################
PAQUETES=(
    #### Powermanagement ####
    'tlp'
    'tlp-rdw'
    'powertop'

    #### Gnome ####
    'gnome-tweaks'
    'gnome-extensions-app'
    'gnome-shell-extension-native-window-placement'
    'gnome-shell-extension-dash-to-dock'
    'gnome-shell-extension-no-overview'
    'gnome-shell-extension-pop-shell'
    'file-roller-nautilus'

    #### WEB ####
    'brave-browser'
    'librewolf'
    'google-chrome-stable'
    'thunderbird'
    'remmina'

    #### Shells ####
    'zsh'
    'dialog'
    'autojump'
    'autojump-zsh'
    'ShellCheck'

    #### Archivos ####
    'mc'
    'thunar'
    'vifm'
    'stow'
    'ripgrep'
    'autofs'

    #### Sistema ####
    'tldr'
    'corectrl'
    'p7zip'
    'unrar'
    'kitty'
    'htop'
    'neofetch'
    'lshw-gui'
    'powerline'
    'klavaro'
    'emacs'
    'fd-find'
    'the_silver_searcher'
    'aspell'
    'pandoc'
    'dconf-editor'
    'setroubleshoot'
    'tmux'

    #### Redes ####
    'nmap'
    'wireshark'
    'firewall-applet'

    #### DEV ####
    'code'
    'git'
    'clang'
    'cmake'
    'meson'
    'python3-pip'
    'filezilla'
    'golang'
    'java-1.8.0-openjdk'
    'lldb'
    'tidy'
    'nodejs'
    'yarnpkg'
    'pcre-cpp'

    #### Fuentes ####
    'fontawesome-fonts'
    'fontforge'
    'google-roboto-fonts'
    'ht-caladea-fonts'

    #### Cockpit ####
    'cockpit-machines'

    #### Virtualizacion ####
    'virt-manager'
    'ebtables-services'
    'bridge-utils'
    'libguestfs'

    #### RPMs ####
    'amazon-corretto-17-x64-linux-jdk.rpm'
    'terminus-fonts-4.49.1-12.fc34.noarch.rpm'
    'cascadia-code-fonts-2102.25-1.fc34.noarch.rpm'
    'fira-code-fonts-5.2-3.fc34.noarch.rpm'
    'xorg-x11-font-utils-7.5-51.fc34.x86_64.rpm'
    'msttcore-fonts-installer-2.6-1.noarch.rpm'
)
 
for PAQ in "${PAQUETES[@]}"; do
    dnf install "$PAQ" -y
done
###############################################################################

############################# Codecs ###########################################
dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y
dnf install lame\* --exclude=lame-devel -y
dnf group upgrade --with-optional Multimedia -y
dnf install ffmpeg -y
################################################################################

################################ Wallpapers #####################################
echo -e "\nInstalando wallpapers..."
git clone https://github.com/gastongmartinez/wallpapers.git
mv -f wallpapers/ "/usr/share/backgrounds/"
#################################################################################

rm ./*.rpm

{
    echo "[User]"
    echo "Session=gnome"
    echo "Icon=/usr/share/backgrounds/wallpapers/Fringe/fibonacci3.jpg"
    echo "SystemAccount=false"
} >"/var/lib/AccountsService/users/$USER"

usermod -aG libvirt "$USER"
usermod -aG kvm "$USER"

systemctl enable --now cockpit.socket
firewall-cmd --add-service=cockpit --permanent

alternatives --set java /usr/lib/jvm/java-17-amazon-corretto/bin/java
alternatives --set javac /usr/lib/jvm/java-17-amazon-corretto/bin/javac

############################### GRUB ############################################
read -rp "Instalar tema Grub? (S/N): " GB
if [[ $GB =~ ^[Ss]$ ]]; then
    git clone https://github.com/vinceliuice/grub2-themes.git
    cd grub2-themes || return
    ./install.sh
    cd .. || return
    rm -rf grub2-themes
fi
#################################################################################

############################### SESSIONS ########################################
if [ ! -d /usr/share/xsessions/ignore ]; then
    mkdir /usr/share/xsessions/ignore
fi
if [ ! -d /usr/share/wayland-sessions/ignore ]; then
    mkdir /usr/share/wayland-sessions/ignore
fi

mv /usr/share/xsessions/xinit-compat.desktop /usr/share/xsessions/ignore/
mv /usr/share/xsessions/gnome-classic* /usr/share/xsessions/ignore/
mv /usr/share/xsessions/gnome-custom-session.desktop /usr/share/xsessions/ignore/
mv /usr/share/wayland-sessions/gnome-classic* /usr/share/wayland-sessions/ignore/

sed -i 's/Name\[es\]=Estándar (servidor gráfico X11)/Name\[es\]=Gnome Xorg/g' "/usr/share/xsessions/gnome.desktop"
sed -i 's/Name\[es\]=Estándar (servidor gráfico X11)/Name\[es\]=Gnome Xorg/g' "/usr/share/xsessions/gnome-xorg.desktop"
sed -i 's/Name\[es\]=Estándar (servidor gráfico Wayland)/Name\[es\]=Gnome Wayland/g' "/usr/share/wayland-sessions/gnome.desktop"
sed -i 's/Name\[es\]=Estándar (servidor gráfico Wayland)/Name\[es\]=Gnome Wayland/g' "/usr/share/wayland-sessions/gnome-wayland.desktop"
#################################################################################

sleep 2

reboot
