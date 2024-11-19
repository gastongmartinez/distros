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

    mysql_secure_installation
fi

# PostgreSQL
read -rp "Instalar PostgreSQL? (S/N): " PSQL
if [[ $PSQL =~ ^[Ss]$ ]]; then
    dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm

    # Disable the built-in PostgreSQL module:
    dnf -qy module disable postgresql

    dnf install -y postgresql17-server

    /usr/pgsql-17/bin/postgresql-17-setup initdb
    systemctl enable --now postgresql-17

    # PGAdmin4
    rpm -i https://ftp.postgresql.org/pub/pgadmin/pgadmin4/yum/pgadmin4-redhat-repo-2-1.noarch.rpm
    dnf install pgadmin4
fi