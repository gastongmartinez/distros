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
    dnf install sqlite
    nix-env -iA nixpkgs.sqlitebrowser
    nix-env -iA nixpkgs.sqlite-analyzer
fi