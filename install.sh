#!/bin/bash

# Script para instalar Ansible, desplegar el contenido del directorio "project" en /var/www/html, ejecutar un playbook de Ansible e importar bases de datos

# Colores para la salida
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# URL del repositorio de GitHub
REPO_URL="https://github.com/alexhl005/app-web.git"
REPO_DIR="app-web"
PROJECT_DIR="project"
ANSIBLE_PLAYBOOK_PATH="/var/www/html/ansible/main.yml"
SQL_DIR="/var/www/html/sql"
VARS_FILE="/var/www/html/ansible/vars/varsMain.yml"
DATABASE_NAME="loansdb"

# Función para solicitar el valor de domainName
ask_domain_name() {
    echo -e "${YELLOW}Por favor, introduce el valor de domainName:${NC}"
    read -r domainName
    if [ -z "$domainName" ]; then
        echo -e "${RED}El valor de domainName no puede estar vacío.${NC}" >&2
        exit 1
    fi
}

# Función para actualizar el archivo varsMain.yml
update_vars_file() {
    echo -e "${YELLOW}Actualizando el archivo varsMain.yml con domainName: $domainName...${NC}"
    if [ -f "$VARS_FILE" ]; then
        sed -i "s/domainName:.*/domainName: $domainName/" "$VARS_FILE"
        if [ $? -ne 0 ]; then
            echo -e "${RED}Error al actualizar el archivo varsMain.yml.${NC}" >&2
            exit 1
        fi
    else
        echo -e "${RED}El archivo $VARS_FILE no existe.${NC}" >&2
        exit 1
    fi
}

# Función para verificar si el script se está ejecutando como root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Este script debe ser ejecutado como root.${NC}" >&2
        exit 1
    fi
}

# Función para verificar si el sistema es Ubuntu o Debian
check_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ "$ID" != "ubuntu" ] && [ "$ID" != "debian" ]; then
            echo -e "${RED}Este script solo es compatible con Ubuntu y Debian.${NC}" >&2
            exit 1
        fi
    else
        echo -e "${RED}No se pudo determinar el sistema operativo.${NC}" >&2
        exit 1
    fi
}

# Función para verificar si el comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Función para instalar dependencias necesarias
install_dependencies() {
    echo -e "${YELLOW}Instalando dependencias necesarias...${NC}"
    sudo apt-get install -y software-properties-common git
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error al instalar dependencias.${NC}" >&2
        exit 1
    fi
}

# Función para agregar el repositorio de Ansible
add_ansible_repo() {
    echo -e "${YELLOW}Agregando el repositorio de Ansible...${NC}"
    sudo apt-add-repository -y ppa:ansible/ansible
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error al agregar el repositorio de Ansible.${NC}" >&2
        exit 1
    fi
}

# Función para actualizar la caché de paquetes
update_package_cache() {
    echo -e "${YELLOW}Actualizando la caché de paquetes...${NC}"
    sudo apt-get update
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error al actualizar la caché de paquetes.${NC}" >&2
        exit 1
    fi
}

# Función para instalar Ansible
install_ansible() {
    echo -e "${YELLOW}Instalando Ansible...${NC}"
    sudo apt-get install -y ansible
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error al instalar Ansible.${NC}" >&2
        exit 1
    fi
}

# Función para verificar la instalación de Ansible
verify_installation() {
    if command_exists ansible; then
        echo -e "${GREEN}Ansible se ha instalado correctamente.${NC}"
        ansible --version
    else
        echo -e "${RED}Ansible no se ha instalado correctamente.${NC}" >&2
        exit 1
    fi
}

# Función para clonar el repositorio de GitHub
clone_repository() {
    echo -e "${YELLOW}Clonando el repositorio de GitHub...${NC}"
    if [ -d "$REPO_DIR" ]; then
        echo -e "${YELLOW}El directorio $REPO_DIR ya existe. Actualizando el repositorio...${NC}"
        cd "$REPO_DIR"
        git pull origin main
        if [ $? -ne 0 ]; then
            echo -e "${RED}Error al actualizar el repositorio.${NC}" >&2
            exit 1
        fi
        cd ..
    else
        git clone "$REPO_URL" "$REPO_DIR"
        if [ $? -ne 0 ]; then
            echo -e "${RED}Error al clonar el repositorio.${NC}" >&2
            exit 1
        fi
    fi
}

# Función para copiar solo el contenido del directorio "project" a /var/www/html
copy_project_files() {
    mkdir -p /var/www/html
    echo -e "${YELLOW}Copiando el contenido de $PROJECT_DIR a /var/www/html...${NC}"

    # Verificar si el directorio "project" existe en el repositorio clonado
    if [ -d "$REPO_DIR/$PROJECT_DIR" ]; then
        # Limpiar /var/www/html antes de copiar
        echo -e "${YELLOW}Limpiando /var/www/html...${NC}"
        sudo rm -rf /var/www/html/*

        # Copiar solo el contenido de "project" a /var/www/html
        sudo cp -r "$REPO_DIR/$PROJECT_DIR"/* /var/www/html/
        if [ $? -ne 0 ]; then
            echo -e "${RED}Error al copiar los archivos.${NC}" >&2
            exit 1
        fi
    else
        echo -e "${RED}El directorio $PROJECT_DIR no existe en el repositorio.${NC}" >&2
        exit 1
    fi
}

# Función para ejecutar el playbook de Ansible
run_ansible_playbook() {
    echo -e "${YELLOW}Ejecutando el playbook de Ansible...${NC}"
    if [ -f "$ANSIBLE_PLAYBOOK_PATH" ]; then
        cd /var/www/html/ansible
        ansible-playbook main.yml
        if [ $? -ne 0 ]; then
            echo -e "${RED}Error al ejecutar el playbook de Ansible.${NC}" >&2
            exit 1
        fi
    else
        echo -e "${RED}El archivo $ANSIBLE_PLAYBOOK_PATH no existe.${NC}" >&2
        exit 1
    fi
}

# Función para verificar e instalar MariaDB
check_and_install_mariadb() {
    echo -e "${YELLOW}Verificando si MariaDB está instalado...${NC}"
    if command_exists mariadb; then
        echo -e "${GREEN}MariaDB ya está instalado.${NC}"
    else
        echo -e "${YELLOW}Instalando MariaDB...${NC}"
        sudo apt-get install -y mariadb-server
        if [ $? -ne 0 ]; then
            echo -e "${RED}Error al instalar MariaDB.${NC}" >&2
            exit 1
        fi
        echo -e "${GREEN}MariaDB se ha instalado correctamente.${NC}"
    fi
}

# Función para crear la base de datos loansdb
create_database() {
    echo -e "${YELLOW}Creando la base de datos $DATABASE_NAME...${NC}"
    sudo mysql -u root -e "CREATE DATABASE IF NOT EXISTS $DATABASE_NAME;"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error al crear la base de datos $DATABASE_NAME.${NC}" >&2
        exit 1
    fi
    echo -e "${GREEN}Base de datos $DATABASE_NAME creada correctamente.${NC}"
}

# Función para importar bases de datos desde la carpeta sql
import_databases() {
    echo -e "${YELLOW}Importando bases de datos desde $SQL_DIR...${NC}"

    if [ -d "$SQL_DIR" ]; then
        for SQL_FILE in "$SQL_DIR"/*.sql; do
            if [ -f "$SQL_FILE" ]; then
                echo -e "${YELLOW}Importando $SQL_FILE...${NC}"
                mysql -u root -D $DATABASE_NAME < "$SQL_FILE"
                if [ $? -ne 0 ]; then
                    echo -e "${RED}Error al importar $SQL_FILE.${NC}" >&2
                    exit 1
                fi
            fi
        done
    else
        echo -e "${RED}El directorio $SQL_DIR no existe.${NC}" >&2
        exit 1
    fi
}

# Función principal
main() {
    check_root
    ask_domain_name
    check_os
    install_dependencies
    add_ansible_repo
    update_package_cache
    install_ansible
    verify_installation
    clone_repository
    copy_project_files
    check_and_install_mariadb
    create_database
    import_databases
    update_vars_file
    run_ansible_playbook
    echo -e "${GREEN}Proceso completado con éxito.${NC}"
}

# Ejecutar la función principal
main

clear
echo -e "${GREEN}Introduce en el navegador: https://$domainName ${NC}"