#!/bin/bash

# Script para instalar Ansible con verificaciones y seguridad mejorada

# Colores para la salida
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

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
    sudo apt-get install -y software-properties-common
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

# Función para copiar el contenido del directorio project a /var/www/html
copy_project_files() {
    echo -e "${YELLOW}Copiando archivos del directorio project a /var/www/html...${NC}"
    sudo cp -r project/* /var/www/html/
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error al copiar los archivos.${NC}" >&2
        exit 1
    fi
}

# Función principal
main() {
    check_root
    check_os
    install_dependencies
    add_ansible_repo
    update_package_cache
    install_ansible
    verify_installation
    copy_project_files
}

# Ejecutar la función principal
main
