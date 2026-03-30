#!/usr/bin/bash

# Validacion de usuario
R_USER=$(id -u)
if [ "$R_USER" -ne 0 ]; then
    echo -e "\nDebe ejecutar este script como root o utilizando sudo.\n"
    exit 1
fi

USER=$(grep "1000" /etc/passwd | awk -F : '{ print $1 }')

############################### Apps Generales ################################
PAQUETES=(
    #### Powermanagement ####
    'tlp'
    'tlp-rdw'
    'tlpui'
    'powertop'

    #### WEB ####
    'firefox'
    'thunderbird'
    'remmina'
    'qbittorrent'

    #### Archivos ####
    'mc'
    'Thunar'
    'thunar-archive-plugin'
    'thunar-media-tags-plugin'
    'thunar-volman'
    'vifm'
    'stow'
    'ripgrep'
    'autofs'
    'ntfs-3g'
    'fuse-exfat'

    #### Sistema ####
    'curl'
    'wget'
    'xz'
    'unzip'
    'zip'
    'nano'
    'vim'
    'cronie'
    'gptfdisk'
    'xtools'
    'mtools'
    'mlocate'
    'linux-headers'
    'gtksourceview4'
    'tldr'
    'helix'
    'lsd'
    'corectrl'
    'p7zip'
    '7zip-unrar'
    'unrar'
    'alacritty'
    'htop'
    'bpytop'
    'lshw'
    'gtk-lshw'
    'neovim'
    'libreoffice'
    'libreoffice-i18n-es'
    'python3-neovim'
    'emacs'
    'flameshot'
    'klavaro'
    'fd'
    'fzf'
    'the_silver_searcher'
    'qalculate'
    'qalculate-qt'
    'calibre'
    'foliate'
    'aspell'
    'pandoc'
    'ulauncher'
    'timeshift'
    'gettext'
    'octoxbps'
    'vsv'
    'flatpak'

    #### Multimedia ####
    'mpv'
    'ffmpeg'
    'mesa-vaapi'
    'gst-libav'

    #### Juegos ####
    'chromium-bsu'
    'retroarch'

    #### Redes ####
    'nmap'
    'zenmap'
    'wireshark'
    'ufw'
    'ufw-extras'
    'gufw'
    #'gns3-gui'
    #'gns3-server'

    #### Diseño ####
    'gimp'
    'inkscape'
    'krita'
    'blender'

    #### DEV ####
    'git'
    'clang'
    'clang-tools-extra'
    'gcc'
    'cmake'
    'meson'
    'python3'
    'python3-pipenv'
    'python3-pip'
    'python3-yamllint'
    'python3-lsp-server'
    'black'
    'pyright'
    'autopep8'
    'filezilla'
    'sbcl'
    'go'
    'lldb'
    'vscode'
    'tidy5'
    'nodejs'
    'yarn'
    'lazygit'
    'pcre'
    'ninja'
    'sassc'

    #### Fuentes ####
    'terminus-font'
    'font-awesome'
    'font-awesome5'
    'font-awesome6'
    'fonts-roboto-ttf'
    'font-fira-ttf'
    'font-firacode'

    ### Bases de datos ###
    'postgresql'
    'postgis'
    'mysql'
    'sqlite'
    'sqlitebrowser'

    ### Virtualizacion ###
    'virt-manager'
    'bridge-utils'
    'libguestfs'

    ### Audio ###
    'pulseaudio'
    'pulsemixer'
    'alsa-plugins-pulseaudio'
    'pavucontrol'

    ### Impresora ###
    'cups'
    'cups-pk-helper'
    'cups-filters'
    'splix'
)
 
for PAQ in "${PAQUETES[@]}"; do
    xbps-install -y "$PAQ"
done
#################################################################################

################################## JDK ##########################################
wget https://corretto.aws/downloads/latest/amazon-corretto-25-x64-linux-jdk.tar.gz
tar -xf amazon-corretto-25-x64-linux-jdk.tar.gz
rm ./amazon-corretto-25-x64-linux-jdk.tar.gz
if [ ! -d /usr/lib/jvm ]; then
    mkdir /usr/lib/jvm
fi
mv amazon* /usr/lib/jvm/java-25-amazon-corretto

{
    echo 'export JAVA_HOME=/usr/lib/jvm/java-25-amazon-corretto'
    echo 'export PATH="$JAVA_HOME"/bin:"$PATH"'
} >>/etc/profile.d/corretto.sh
#################################################################################

################################ Wallpapers #####################################
echo -e "\nInstalando wallpapers..."
git clone https://github.com/gastongmartinez/wallpapers.git
mv -f wallpapers/ "/usr/share/backgrounds/"
#################################################################################

usermod -aG libvirt "$USER"
usermod -aG kvm "$USER"

ufw enable
ufw allow ssh

########################### Habilitacion de servicios ###########################
ln -s /etc/sv/tlp /var/service
ln -s /etc/sv/cronie /var/service
ln -s /etc/sv/cupsd /var/service
#################################################################################

############################## Nix Package Manager ##############################
xbps-install -y nix
ln -s /etc/sv/nix-daemon /var/service/
# shellcheck source=/dev/null
source /etc/profile
chown "$USER" "/nix/var/nix/profiles/per-user/$USER"
chown "$USER" "/nix/var/nix/gcroots/per-user/$USER"
#################################################################################

sleep 2

reboot