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
    'calibre'
    'foliate'
    'pandoc'
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

    #### Redes ####
    'nmap'
    'wireshark'
    'firewall-applet'

    #### Diseño ####
    'gimp'
    'inkscape'
    'krita'
    'blender'

    #### DEV ####
    'clang'
    'cmake'
    'meson'
    'pipenv'
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
    'cockpit-networkmanager'
    'cockpit-podman'

    #### Virtualizacion ####
    'virt-manager'
    'ebtables'
    'bridge-utils'
)

for PAQ in "${PAQUETES[@]}"; do
    nala install "$PAQ" -y
done

#### Gnome Apps####
read -rp "Instalar GNOME Apps? (S/N): " GAPPS
if [[ $GAPPS =~ ^[Ss]$ ]]; then
    GNAPPS=(
        'gnome-feeds'
        'gnome-shell-extension-dashtodock'
        'gnome-shell-extension-caffeine'
        'gnome-shell-extension-tiling-assistant'
        'gnome-commander'
        'gnome-software-plugin-flatpak'
        'dconf-editor'
        'qalculate-gtk'
    )

    for PAQ in "${GNAPPS[@]}"; do
        nala install "$PAQ" -y
    done

    # Icono
    {
        echo '[User]'
        echo 'Icon=/usr/share/backgrounds/wallpapers/Fringe/fibonacci3.jpg'
        echo 'SystemAccount=false'
    } >>"/var/lib/AccountsService/users/$USER"
fi

#'qalculate-gtk'

wget https://corretto.aws/downloads/latest/amazon-corretto-21-x64-linux-jdk.deb
wget https://github.com/Ulauncher/Ulauncher/releases/download/5.15.7/ulauncher_5.15.7_all.deb
apt install ./amazon-corretto-21-x64-linux-jdk.deb -y
apt install ./ulauncher_5.15.7_all.deb -y
###############################################################################

################################ Wallpapers #####################################
echo -e "\nInstalando wallpapers..."
git clone https://github.com/gastongmartinez/wallpapers.git
mv -f wallpapers/ "/usr/share/backgrounds/"
#################################################################################

#################################################################################
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
rm amazon-corretto-21-x64-linux-jdk.deb
rm ulauncher_5.15.7_all.deb

sleep 2

reboot