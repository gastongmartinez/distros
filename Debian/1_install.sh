#!/usr/bin/env bash

# Validacion del usuario ejecutando el script
R_USER=$(id -u)
if [ "$R_USER" -ne 0 ];
then
    echo -e "\nDebe ejecutar este script como root.\n"
    exit 1
fi

USER=$(grep "1000" /etc/passwd | awk -F : '{ print $1 }')

############################### Apps Generales ################################
PAQUETES=(
    #### Powermanagement ####
    'tlp'
    'tlp-rdw'
    'powertop'

    #### Gnome ####
    'gnome-feeds'
    'gnome-shell-extension-dashtodock'
    'gnome-shell-extension-caffeine'
    'gnome-shell-extension-tiling-assistant'
    'gnome-commander'

    #### WEB ####
    'google-chrome-stable'
    'librewolf'
    'brave-browser'
    'thunderbird'
    'remmina'
    'qbittorrent'

    #### Shells ####
    'zsh'
    'zsh-autosuggestions'
    'zsh-syntax-highlighting'
    'dialog'
    'autojump'
    'shellcheck'

    #### Archivos ####
    'mc'
    'thunar'
    'vifm'
    'stow'
    'ripgrep'
    'autofs'

    #### Sistema ####
    'flatpak'
    'gnome-software-plugin-flatpak'
    'tldr'
    'lsd'
    'unrar-free'
    'alacritty'
    'kitty'
    'htop'
    'bpytop'
    'neofetch'
    'lshw'
    'lshw-gtk'
    'powerline'
    'emacs'
    'flameshot'
    'klavaro'
    'fd-find'
    'fzf'
    'silversearcher-ag'
    'qalculate-gtk'
    'calibre'
    'foliate'
    'pandoc'
    'dconf-editor'
    'gettext'
    'stacer'
    'tmux'

    #### Multimedia ####
    'vlc'
    'python3-vlc'
    'mpv'
    'lame'
    'ffmpeg'
    'libavcodec-extra'

    #### Juegos ####
    'chromium-bsu'
    'retroarch'

    #### Redes ####
    'nmap'
    'wireshark'
    'wireshark-gtk'
    'firewall-applet'

    #### Diseño ####
    'gimp'
    'inkscape'
    #'krita'
    #'blender'

    #### DEV ####
    'clang'
    'cmake'
    'meson'
    'pipenv'
    #'python3-spyder'
    'python3-pip'
    'pipx'
    'filezilla'
    'sbcl'
    'golang'
    'lldb'
    'code'
    'tidy'
    'nodejs'
    'npm'
    'yarnpkg'

    #### Fuentes ####
    'fonts-terminus'
    'fonts-font-awesome'
    'fonts-roboto'
    'fonts-firacode'
    'cabextract'
    'fonts-crosextra-caladea'
    'fontforge'
    'ttf-mscorefonts-installer'

    #### Bases de datos ####
    'postgresql'
    'postgis'
    'sqlite3'
    'sqlite3-tools'
    'sqlitebrowser'
    'mariadb-server'

    #### Cockpit ####
    'cockpit'
    'cockpit-sosreport'
    'cockpit-machines'
    'cockpit-podman'

    #### Virtualizacion ####
    'virt-manager'
    'ebtables'
    'bridge-utils'

    #### Window Managers ####
    'awesome'
    'nitrogen'
    'feh'
    'picom'
    'lxappearance'
    'jgmenu'
    'i3lock'
    'i3lock-fancy'
    'sway'
    'sway-notification-center'
    'swayidle'
    'swayimg'
    'swaykbdd'
    'swaylock'
    'grimshot'
    'waybar'
    'wofi'
    'wlr-randr'
    'wlogout'
    'pavucontrol'
)

for PAQ in "${PAQUETES[@]}"; do
    nala install "$PAQ" -y
done

wget https://corretto.aws/downloads/latest/amazon-corretto-17-x64-linux-jdk.deb
wget https://github.com/Ulauncher/Ulauncher/releases/download/5.15.2/ulauncher_5.15.2_all.deb
apt install ./amazon-corretto-17-x64-linux-jdk.deb -y
apt install ./ulauncher_5.15.2_all.deb -y
###############################################################################

################################ Wallpapers #####################################
echo -e "\nInstalando wallpapers..."
git clone https://github.com/gastongmartinez/wallpapers.git
mv -f wallpapers/ "/usr/share/backgrounds/"
#################################################################################

#################################################################################
# Icono
{
    echo '[User]'
    echo 'Icon=/usr/share/backgrounds/wallpapers/Fringe/fibonacci3.jpg'
    echo 'SystemAccount=false'
} >>"/var/lib/AccountsService/users/$USER"
sed -i "s/Name=awesome/Name=Awesome/g" "/usr/share/xsessions/awesome.desktop"

usermod -aG libvirt "$USER"
usermod -aG kvm "$USER"

systemctl enable --now cockpit.socket
firewall-cmd --add-service=cockpit
firewall-cmd --add-service=cockpit --permanent
#################################################################################

############################### GRUB ############################################
git clone https://github.com/vinceliuice/grub2-themes.git
cd grub2-themes || return
./install.sh
cd .. || return
#################################################################################

rm -rf grub2-themes
rm amazon-corretto-17-x64-linux-jdk.deb
rm ulauncher_5.15.2_all.deb

sleep 2

reboot