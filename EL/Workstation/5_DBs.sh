#!/usr/bin/env bash

# Validacion del usuario ejecutando el script
R_USER=$(id -u)
if [ "$R_USER" -ne 0 ]; then
    echo -e "\nDebe ejecutar este script como root o utilizando sudo.\n"
    exit 1
fi

export LANG=en_US.UTF-8

# MySQL
read -rp "Instalar MySQL? (S/N): " MYSQL
if [[ $MYSQL =~ ^[Ss]$ ]]; then
    dnf install -y https://dev.mysql.com/get/mysql84-community-release-el9-1.noarch.rpm
    dnf install -y mysql-community-server

    dnf install -y https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-8.0.40-1.el9.x86_64.rpm

    systemctl enable --now mysqld
    
    RT_PASSWD=$(grep "temporary" /var/log/mysqld.log | awk -F ': ' '{ print $2 }')

    echo -e "\nEstablecer el password para root@localhost usando:\n"
    echo -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass';\n"

    mysql -u root -p"$RT_PASSWD"
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
    dnf install -y pgadmin4
fi

# Oracle
read -rp "Instalar Oracle 23ai Free? (S/N): " ORA
if [[ $ORA =~ ^[Ss]$ ]]; then
    dnf install -y https://yum.oracle.com/repo/OracleLinux/OL9/appstream/x86_64/getPackage/oracle-database-preinstall-23ai-1.0-2.el9.x86_64.rpm
    dnf install -y https://download.oracle.com/otn-pub/otn_software/db-free/oracle-database-free-23ai-1.0-1.el9.x86_64.rpm

    /etc/init.d/oracle-free-23ai configure

    dnf install -y https://download.oracle.com/otn_software/java/sqldeveloper/sqldeveloper-24.3.0-284.2209.noarch.rpm
    dnf install -y https://download.oracle.com/otn_software/java/sqldeveloper/datamodeler-24.3.0.240.1210-1.noarch.rpm
fi

# MS SQL
read -rp "Instalar MS SQL Server? (S/N): " MS
if [[ $MS =~ ^[Ss]$ ]]; then
    curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/9/mssql-server-2022.repo
    dnf install -y mssql-server

    /opt/mssql/bin/mssql-conf setup

    firewall-cmd --zone=public --add-port=1433/tcp --permanent
    firewall-cmd --reload

    wget --output-document azuredatastudio.rpm https://azuredatastudio-update.azurewebsites.net/latest/linux-rpm-x64/stable
    dnf install -y ./azuredatastudio.rpm
    rm ./*.rpm
fi

