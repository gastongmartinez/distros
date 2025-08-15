#!/usr/bin/env bash

# Validacion del usuario ejecutando el script
R_USER=$(id -u)
if [ "$R_USER" -ne 0 ]; then
    echo -e "\nDebe ejecutar este script como root o utilizando sudo.\n"
    exit 1
fi

# Configuracion DNF
{
    echo 'fastestmirror=1'
    echo 'max_parallel_downloads=10'
} >> /etc/dnf/dnf.conf
dnf update -y

# Ajuste Swappiness
echo -e "vm.swappiness=10\n" >> /etc/sysctl.d/90-sysctl.conf

# Cockpit
systemctl enable --now cockpit.socket
firewall-cmd --add-service=cockpit --permanent

# Apps
dnf install -y mc
dnf install -y tmux
dnf install -y git

# Oracle 23ai
dnf install -y https://download.oracle.com/otn-pub/otn_software/db-free/oracle-database-free-23ai-23.8-1.el9.x86_64.rpm

/etc/init.d/oracle-free-23ai configure