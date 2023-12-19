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

    #### WEB ####
    'chromium'
    'MozillaThunderbird'
    'remmina'
    'qbittorrent'
    'brave-browser'
    'google-chrome-stable'

    #### Shells ####
    'zsh'
    'zsh-autosuggestions'
    'zsh-syntax-highlighting'
    'alacritty-bash-completion'
    'alacritty-zsh-completion'
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
    'helix'
    'lsd'
    'unrar'
    'alacritty'
    'kitty'
    'conky'
    'ntp'  
    'htop'
    'neofetch'
    'lshw'
    'lshw-gui'
    'neovim'
    'emacs'
    'code'
    'flameshot'
    'klavaro'
    'xdpyinfo'
    'the_silver_searcher'
    'fzf'
    'qalculate'
    'qalculate-gtk'
    'aspell'
    'powerline'
    'foliate'
    'pandoc-cli'
    'rofi'
    'tmux'
    'tmux-powerline'
    'zellij'
    'tealdeer'
    'libgtop-devel'
    'ulauncher'
    'corectrl'
    
    #### Multimedia ####
    'vlc'
    'mpv'
    'handbrake-gtk'
    'blanket'

    #### Juegos ####
    'chromium-bsu'
    'retroarch'

    #### Redes ####
    'nmap'
    'wireshark-ui-qt'
    'firewall-config'
    'firewall-applet'
    #'gns3-gui'
    #'gns3-server'
    #'python310-gns3fy'

    #### Diseño ####
    'gimp'
    'inkscape'
    'krita'
    'blender'
       
    #### Fuentes ####
    'terminus-bitmap-fonts'
    'ubuntu-fonts'
    'saja-cascadia-code-fonts'
    'google-roboto-mono-fonts'
    'google-roboto-slab-fonts'
    'fetchmsttfonts'
    'iosevka-fonts'
    'google-caladea-fonts'
    'fira-code-fonts'
  
    # Dev
    'git'
    'go'
    'lazygit'
    'clang'
    'make'
    'cmake'
    'meson'
    'filezilla'
    'sbcl'
    'tidy'
    'sassc'
    'nodejs20'
    'yarn'
    'java-1_8_0-openjdk'
    'gcc-c++'
    'java-17-amazon-corretto-devel'
    'java-21-amazon-corretto-devel'
    'python311-pipx'

    # PostgreSQL
    'postgresql-server'
    'postgresql-plpython'
    'postgresql15-postgis'
    'postgresql15-postgis-utils'
    'pgadmin4'
    'pgadmin4-web-uwsgi'
    'mariadb'
    'sqlite3'
    'sqlitebrowser'

    # Cockpit
    'cockpit'
    'cockpit-machines'
    'cockpit-podman'

    # Virtualizacion
    'virt-manager'
    'qemu-extra'
    'vde2'
    'bridge-utils'
    'libvirt'
    'virtualbox'
    'virtualbox-guest-tools'
    'virtualbox-qt'

    # WM
    'awesome'
    'dmenu'
    'nitrogen'       
    'feh'
    'picom'
    'lxappearance'
    'qtile'
    'jgmenu'
    'sway'
    'wlr-randr'

    # Codecs
    'gstreamer-plugin-openh264'
    'gstreamer-plugins-bad-codecs'
    'gstreamer-plugins-ugly-codecs'
)
for PAQ in "${PAQUETES[@]}"; do
    zypper install -y "$PAQ"
done
#################################################################################

################################ Wallpapers #####################################
echo -e "\nInstalando wallpapers..."
git clone https://github.com/gastongmartinez/wallpapers.git
mv -f wallpapers/* "/usr/share/wallpapers"
rm -rf wallpapers
#################################################################################

# Permisos
USER=$(grep "1000" /etc/passwd | awk -F : '{ print $1 }')
usermod -aG libvirt "$USER"
usermod -aG kvm "$USER"
usermod -aG vboxusers "$USER"

# Gnome
read -rp "Se instala en Gnome? (S/N): " GN
if [[ $GN =~ ^[Ss]$ ]]; then
    zypper install -y gnome-shell-extension-user-theme
    #zypper install -y gnome-shell-extension-pop-shell
    zypper install -y gnome-commander
    zypper install -y nautilus-file-roller

    {
        echo '[User]'
        echo 'Icon=/usr/share/wallpapers/Fringe/fibonacci3.jpg'
        echo 'SystemAccount=false'
    } >>"/var/lib/AccountsService/users/$USER"
fi

# Habilitar cockpit
systemctl enable --now cockpit.socket
firewall-cmd --add-service=cockpit
firewall-cmd --add-service=cockpit --permanent

# Habilitar reinicio
echo -e "$USER ALL=NOPASSWD:/usr/sbin/reboot\n" >> /etc/sudoers

sed -i 's/Name=awesome/Name=Awesome/g' "/usr/share/xsessions/awesome.desktop"

update-alternatives --set java /usr/lib/jvm/java-17-amazon-corretto/bin/java
update-alternatives --set javac /usr/lib/jvm/java-17-amazon-corretto/bin/javac

# Grub Full HD
read -rp "Cambiar resolucion de GRUB a 1920x1080? (S/N): " RES
if [[ $RES =~ ^[Ss]$ ]]; then
    sed -i 's/GRUB_GFXMODE=\"auto\"/GRUB_GFXMODE=1920x1080/g' "/etc/default/grub"
    update-bootloader
fi

sleep 2

reboot