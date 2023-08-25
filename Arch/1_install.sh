#!/usr/bin/env bash

# Validacion del usuario ejecutando el script
R_USER=$(id -u)
if [ "$R_USER" -ne 0 ];
then
    echo -e "\nDebe ejecutar este script como root o utilizando sudo.\n"
    exit 1
fi

USUARIO=$(grep "1000" /etc/passwd | awk -F : '{ print $1 }')

# MirrorList
pacman -S rsync --noconfirm --needed
pacman -S reflector --noconfirm --needed
echo -e "\nActualizando mirrorlist\n"
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.OLD
reflector --verbose --latest 25 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syu

# Swappiness
echo -e "vm.swappiness=10\n" >> /etc/sysctl.d/99-sysctl.conf

# SSH
systemctl enable sshd

#######################  Hardware & Drivers  #######################
echo -e "\nSeleccion de paquetes para el hardware del equipo.\n"

# Wifi
read -rp "Desea instalar WPA Supplicant (S/N): " WIFI
if [ "$WIFI" == "S" ];
then
    pacman -S wpa_supplicant --noconfirm --needed
fi
# Bluetooth
read -rp "Desea instalar Bluetooth (S/N): " BT
if [ "$BT" == "S" ];
then
    pacman -S bluez --noconfirm --needed
    pacman -S bluez-utils --noconfirm --needed
    systemctl enable bluetooth
fi

# SSD
read -rp "Se instala en un SSD (S/N): " SSD
if [ "$SSD" == "S" ];
then
    pacman -S util-linux --noconfirm --needed
    systemctl enable fstrim.service
    systemctl enable fstrim.timer
fi

# Microcode
read -rp "Instalar microcode I=Intel - A=AMD: " MC
if [ "$MC" == "A" ];
then
    pacman -S amd-ucode --noconfirm --needed
else
    pacman -S intel-ucode --noconfirm --needed
fi

# Video
read -rp "Instalar drivers de Video AMD (S/N): " VAMD
if [ "$VAMD" == "S" ];
then
    pacman -S xf86-video-amdgpu --noconfirm --needed
fi
read -rp "Instalar drivers de Video Intel (S/N): " VINT
if [ "$VINT" == "S" ];
then
    pacman -S xf86-video-intel --noconfirm --needed
fi

# Touchpad
read -rp "Instalar drivers para touchpad (S/N): " TOUCH
if [ "$TOUCH" == "S" ];
then
    pacman -S xf86-input-libinput --noconfirm --needed
fi

# Teclado
# localectl set-x11-keymap es pc105 winkeys

############################### Pacman ################################
PKGS=(
    #### Powermanagement ####
    'acpi'
    'acpi_call'
    'acpid'
    'tlp'
    'powertop'

    #### Gnome ####
    'gnome-extra'
    'chrome-gnome-shell'
    
    #### WEB ####
    'wget'
    'chromium'
    'firefox'
    'thunderbird'
    'remmina'
    'qbittorrent'

    #### Shells ####
    'bash-completion'
    'zsh'
    'zsh-autosuggestions'
    'zsh-syntax-highlighting'
    'shellcheck'

    #### Archivos ####
    'thunar'
    'thunar-archive-plugin'
    'thunar-media-tags-plugin'
    'thunar-volman'
    'p7zip'
    'unrar'
    'fd'
    'mc'
    'vifm'
    'fzf'
    'meld'
    'stow'
    'ripgrep'
    'exfat-utils'
    'autofs'
    'ntfs-3g'

    #### Fuentes ####
    'terminus-font'
    'ttf-roboto'
    'ttf-roboto-mono'
    'ttf-dejavu'
    'powerline-fonts'
    'ttf-ubuntu-font-family'
    'ttf-font-awesome'
    'ttf-cascadia-code' 
    'ttf-jetbrains-mono-nerd'

    #### Terminales ####
    'alacritty'
    'kitty'

    #### Sistema ####
    'ntp'
    'conky'
    'bpytop'
    'neofetch'
    'man'
    'os-prober'
    'pkgfile'
    'lshw'
    'powerline'
    'flameshot'
    'ktouch'
    'foliate'
    'cockpit'
    'cockpit-machines'
    'cockpit-podman'
    'tldr'
    'lsd'
    'corectrl'
    'qalculate-gtk'
    'calibre'
    'aspell'
    'tmux'
    
    #### Editores ####
    'neovim'
    'helix'
    'emacs'
    'code'
    'libreoffice-fresh'
    'libreoffice-fresh-es'

    #### Multimedia ####
    'vlc'
    'mpv'

    #### Juegos ####
    'chromium-bsu'
    'retroarch'
    
    #### Redes ####
    'firewalld'
    'nmap'
    'wireshark-qt'
    'inetutils'
    'dnsutils'
    'nfs-utils'
    'nss-mdns'

    #### Diseño ####
    'gimp'
    'inkscape'
    #'krita'
    #'blender'
    #'freecad'

    #### DEV ####
    'the_silver_searcher'
    'cmake'
    'filezilla'
    'go'
    'python-pip'
    'python-pipenv'
    'jdk-openjdk'
    'nodejs'
    'npm'
    'yarn'
    'lldb'
    'lazygit'
    'tidy'

    #### Bases de datos ####
    'postgresql'
    'postgis'
    'pgadmin4'
    'mariadb'
    'sqlite-analyzer'
    'sqlitebrowser'
    'mysql-workbench'

    #### Virtualizacion ####
    'virt-manager'
    'qemu'
    'qemu-arch-extra'
    'ovmf'
    'ebtables'
    'vde2'
    'dnsmasq'
    'bridge-utils'
    'openbsd-netcat'

    #### Window Managers ####
    'qtile'
    'awesome'
    'nitrogen'
    'feh'
    'picom'
    'lxappearance'
    'xorg-server-xephyr'
    'jgmenu'
    'i3lock'
    'sway'
    'swaybg'
    'swayidle'
    'swayimg'
    'swaylock'
    'waybar'
    'wofi'
    'pavucontrol'
    'hyprland'
    'xdg-desktop-portal-hyprland'

    #### Codecs ####
    'gstreamer-vaapi'
    'gst-libav'
    'gst-plugins-ugly'
)

# Instalacion de paquetes desde los repositorios de Arch 
for PAC in "${PKGS[@]}"; do
    pacman -S "$PAC" --noconfirm --needed --needed
done

#######################################################################
sed -i 's/Name=awesome/Name=Awesome/g' "/usr/share/xsessions/awesome.desktop"

usermod -G libvirt -a "$USUARIO"
systemctl enable libvirtd
systemctl enable tlp
systemctl enable acpid
systemctl enable avahi-daemon
# Firewall
systemctl enable --now firewalld.service

# Cockpit
systemctl enable --now cockpit.socket
firewall-cmd --add-service=cockpit
firewall-cmd --add-service=cockpit --permanent

# Nombre Usuario
echo -e "\nAgregar el nombre completo para el usuario: $USUARIO?.\n"
read -rp "Ingrese el nombre completo del usuario (para omitir dejar en blanco): " NOMBRE
if [ -n "$NOMBRE" ]; then
    usermod -c "$NOMBRE" "$USUARIO"
fi

# PARU
su - "$USUARIO" <<EOF
    cd /tmp
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
EOF

# Wallpapers
git clone https://github.com/gastongmartinez/wallpapers.git
mv wallpapers /usr/share/backgrounds/

# Icono Usuario
{
    echo "[User]"
    echo "Icon=/var/lib/AccountsService/icons/$USUARIO"
    echo "SystemAccount=false    "
} > /var/lib/AccountsService/users/"$USUARIO"
cp /usr/share/backgrounds/wallpapers/Fringe/fibonacci3.jpg /var/lib/AccountsService/icons/"$USUARIO"

# Tema Grub
pacman -S grub-theme-vimix --noconfirm --needed
echo -e '\nGRUB_THEME="/usr/share/grub/themes/Vimix/theme.txt"' >> /etc/default/grub
# Resolucion Grub
read -rp "Configurar Grub en 1920x1080? (S/N): " GB
if [ "$GB" == 'S' ]; then
    sed -i 's/auto/1920x1080x32/g' "/etc/default/grub"
fi
grub-mkconfig -o /boot/grub/grub.cfg