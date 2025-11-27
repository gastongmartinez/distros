#!/usr/bin/env bash

# Validacion del usuario ejecutando el script
R_USER=$(id -u)
if [ "$R_USER" -ne 0 ]; then
    echo -e "\nDebe ejecutar este script como root o utilizando sudo.\n"
    exit 1
fi

read -rp "Establecer el password para root? (S/N): " PR
if [[ $PR =~ ^[Ss]$ ]]; then
    passwd root
fi

read -rp "Establecer el nombre del equipo? (S/N): " HN
if [[ $HN =~ ^[Ss]$ ]]; then
    read -rp "Ingrese el nombre del equipo: " EQUIPO
    if [ -n "$EQUIPO" ]; then
        echo -e "$EQUIPO" > /etc/hostname
    fi
fi

apt install curl -y

# Ajuste Swappiness y Config GRUB
su - root <<EOF
        echo -e "vm.swappiness=10\n" >> /etc/sysctl.d/90-sysctl.conf
        echo -e "GRUB_DISABLE_OS_PROBER=false\n" >> /etc/default/grub 
EOF

# PGAdmin repo
# curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg
# sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list'

# Actualizacion
snap refresh
apt update -y
apt upgrade -y

# Instalacion de herramientas
apt install openssh-server -y
apt install nala -y

# Activacion SSH
systemctl enable ssh

# Configuracion de servidores
nala fetch
nala update