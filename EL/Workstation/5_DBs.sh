#!/usr/bin/env bash

# Validacion del usuario ejecutando el script
R_USER=$(id -u)
if [ "$R_USER" -ne 0 ]; then
    echo -e "\nDebe ejecutar este script como root o utilizando sudo.\n"
    exit 1
fi

export LANG=en_US.UTF-8

# SQLite
read -rp "Instalar SQLite? (S/N): " LITE
if [[ $LITE =~ ^[Ss]$ ]]; then
    dnf install -y sqlite
    nix-env -iA nixpkgs.sqlitebrowser
    nix-env -iA nixpkgs.sqlite-analyzer
fi

# MySQL
read -rp "Instalar MySQL? (S/N): " MYSQL
if [[ $MYSQL =~ ^[Ss]$ ]]; then
    dnf install -y https://dev.mysql.com/get/mysql84-community-release-el9-1.noarch.rpm
    dnf install -y mysql-community-server

    dnf install -y https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-8.0.40-1.el9.x86_64.rpm
fi
