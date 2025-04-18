#!/usr/bin/env bash

# Validacion del usuario ejecutando el script
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
    'powertop'

    #### Gnome ####
    'gnome-tweaks'
    'gnome-feeds'
    'chrome-gnome-shell'
    'gnome-shell-extension-manager'
    'gnome-shell-extensions'
    'gnome-commander'

    #### WEB ####
    'qbittorrent'

    #### Shells ####
    'zsh'
    'zsh-autosuggestions'
    'zsh-syntax-highlighting'
    'autojump'
    'shellcheck'

    #### Archivos ####
    'mc'
    'thunar'
    'thunar-archive-plugin'
    'thunar-media-tags-plugin'
    'vifm'
    'stow'
    'ripgrep'
    'autofs'

    #### Sistema ####
    'tldr'
    'lsd'
    'corectrl'
    'p7zip'
    'unrar'
    'alacritty'
    'kitty'
    'htop'
    'bpytop'
    'neofetch'
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
    'anki'
    'aspell-es'
    'pandoc'
    'dconf-editor'
    #'ulauncher'
    'synaptic'
    'stacer'
    'timeshift'
    'gettext'
    'flatpak'
    'gnome-software-plugin-flatpak'

    #### Multimedia ####
    'vlc'
    'python3-vlc'
    'mpv'
    'handbrake'

    #### Codecs ####
    'x264'
    'gstreamer1.0-plugins-bad'
    'gstreamer1.0-plugins-bad-apps'
    'lame'

    #### Juegos ####
    'chromium-bsu'
    'retroarch'

    #### Redes ####
    'nmap'
    'nmapsi4'
    'wireshark'
    'wireshark-gtk'
    'gufw'

    #### Diseño ####
    'gimp'
    'inkscape'
    #'krita'
    #'blender'

    #### DEV ####
    'clang'
    'sassc'
    'cmake'
    'meson'
    'pipenv'
    'python3-pip'
    'pipx'
    'filezilla'
    'sbcl'
    'golang'
    'lldb'
    'tidy'
    'nodejs'
    'npm'
    'yarnpkg'
    #'lazygit'
    #'pcre-cpp'

    #### Fuentes ####
    'fonts-terminus'
    'fonts-font-awesome'
    'fonts-cascadia-code'
    'fonts-roboto'
    'fonts-dejavu'
    'fonts-firacode'
    'fonts-crosextra-caladea'
    'fonts-crosextra-carlito'
    'ttf-mscorefonts-installer'

    ### Bases de datos ###
    'postgresql'
    'pgadmin4'
    'postgis'
    'mysql-server'
    'sqlite3'
    'sqlite3-tools'
    'sqlitebrowser'

    ### Cockpit ###
    'cockpit'
    'cockpit-sosreport'
    'cockpit-machines'
    'cockpit-podman'

    ### Virtualizacion ###
    'virt-manager'
    'ebtables'
    'bridge-utils'
)
 
for PAQ in "${PAQUETES[@]}"; do
    nala install "$PAQ" -y
done

wget https://corretto.aws/downloads/latest/amazon-corretto-17-x64-linux-jdk.deb
apt install ./amazon-corretto-17-x64-linux-jdk.deb -y
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install ./google-chrome-stable_current_amd64.deb -y
################################################################################

############################### SNAPS ##########################################
snap install brave
snap install mysql-workbench-community
snap install marktext
snap install g4music
snap install nvim --classic
snap install code --classic
snap install gitkraken --classic
snap install obsidian --classic
snap install blanket --edge
################################################################################

################################ Wallpapers #####################################
echo -e "\nInstalando wallpapers..."
git clone https://github.com/gastongmartinez/wallpapers.git
mv -f wallpapers/ "/usr/share/backgrounds/"
#################################################################################

############################### GRUB ############################################
git clone https://github.com/vinceliuice/grub2-themes.git
cd grub2-themes || return
./install.sh
cd .. || return
#################################################################################

rm ./*.deb
rm -rf grub2-themes

# Icono
{
    echo '[User]'
    echo 'Icon=/usr/share/backgrounds/wallpapers/Fringe/fibonacci3.jpg'
    echo 'SystemAccount=false'
} >>"/var/lib/AccountsService/users/$USER"

usermod -aG libvirt "$USER"
usermod -aG kvm "$USER"

systemctl enable --now cockpit.socket

sleep 2

reboot
