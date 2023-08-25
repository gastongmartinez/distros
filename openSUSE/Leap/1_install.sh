#!/bin/bash

# Validacion del usuario ejecutando el script
R_USER=$(id -u)
if [ "$R_USER" -ne 0 ]; then
    echo -e "\nDebe ejecutar este script como root o utilizando sudo.\n"
    exit 1
fi

read -rp "Desea establecer el password para root? (S/N): " PR
if [[ $PR =~ ^[Ss]$ ]]; then
    passwd root
fi

read -rp "Desea establecer el nombre del equipo? (S/N): " HN
if [[ $HN =~ ^[Ss]$ ]]; then
    read -rp "Ingrese el nombre del equipo: " EQUIPO
    if [ -n "$EQUIPO" ]; then
        echo -e "$EQUIPO" > /etc/hostname
    fi
fi

systemctl enable sshd
firewall-cmd --zone=public --permanent --add-service=ssh

# Ajuste Swappiness
echo -e "vm.swappiness=10\n" >> /etc/sysctl.d/90-sysctl.conf

################################ Apps Generales #################################
PAQUETES=(
    #### Powermanagement ####
    'powertop'
    
    #### Gnome ####
    'gnome-shell-extension-user-theme'
    'nautilus-file-roller'

    #### WEB ####
    'qbittorrent'
    'brave-browser'

    #### Terminales ####
    'kitty'
    'alacritty'

    #### Shells ####
    'zsh'
    'ShellCheck'
    'autojump'

    #### Archivos ####
    'thunar'
    'fd'
    'mc'
    'vifm'  
    'meld'
    'stow'
    'ripgrep'
    'fuse-exfat'

    #### Sistema ####
    'unrar'
    'ntp'  
    'htop'
    'neofetch'
    'lshw'
    'flameshot'
    'xdpyinfo'
    'the_silver_searcher'
    'fzf'
    'aspell'
    'powerline'
    'foliate'
    'pandoc'
    
    #### Editores ####
    'emacs'

    #### Redes ####
    'nmap'
    'nmapsi4'
    'wireshark-ui-qt'
    'firewall-config'
    'firewall-applet'    
      
    #### Fuentes ####
    'terminus-bitmap-fonts'
    'ubuntu-fonts'
    'fontawesome-fonts'
    'saja-cascadia-code-fonts'
    'google-roboto-mono-fonts'
    'fetchmsttfonts'
  
    #### Dev ####
    'code'
    'git'
    'go'
    'clang'
    'cmake'
    'meson'
    'sassc'
    'filezilla'
    'nodejs18'
    'npm18'
    'java-1_8_0-openjdk'
    'gcc-c++'
    'gettext-tools'
    'java-17-amazon-corretto-devel'

    #### Bases de datos ####
    'postgresql-server'
    'postgresql-plpython'
    'pgadmin4'
    'pgadmin4-web-uwsgi'

    #### Virtualizacion ###
    'virt-manager'
    'qemu'
    'qemu-extra'
    'vde2'
    'bridge-utils'

    #### Window Managers ####
    'awesome'
    'nitrogen'       
    'feh'
    'picom'
    'lxappearance'
)
for PAQ in "${PAQUETES[@]}"; do
    zypper install -y "$PAQ"
done
#################################################################################

################################ Wallpapers #####################################
echo -e "\nInstalando wallpapers..."
git clone https://github.com/gastongmartinez/wallpapers.git
mv -f wallpapers/ "/usr/share/backgrounds/"
#################################################################################

# Permisos
USER=$(grep "1000" /etc/passwd | awk -F : '{ print $1 }')

sed -i 's/Name=awesome/Name=Awesome/g' "/usr/share/xsessions/awesome.desktop"

# Icono
{
    echo '[User]'
    echo 'Icon=/usr/share/backgrounds/Fringe/fibonacci3.jpg'
    echo 'SystemAccount=false'
} >>"/var/lib/AccountsService/users/$USER"

# Habilitar reinicio
echo -e "$USER ALL=NOPASSWD:/sbin/reboot\n" >> /etc/sudoers

# Version Python
update-alternatives --install /usr/bin/python3 python /usr/bin/python3.11 1

# Grub Full HD
read -rp "Cambiar resolucion de GRUB a 1920x1080? (S/N): " RES
if [[ $RES =~ ^[Ss]$ ]]; then
    sed -i 's/GRUB_GFXMODE=\"auto\"/GRUB_GFXMODE=1920x1080/g' "/etc/default/grub"
    update-bootloader
fi

sleep 2

reboot