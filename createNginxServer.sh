#!/bin/bash

##
# BASH menu script that checks:
#   - Memory usage
#   - CPU load
#   - Number of TCP connections 
#   - Kernel version
##

server_name=$(hostname)

function memory_check() {
    echo ""
	echo "Memory usage on ${server_name} is: "
	free -h
	echo ""
}

function cpu_check() {
    echo ""
	echo "CPU load on ${server_name} is: "
    echo ""
	uptime
    echo ""
}

function tcp_check() {
    echo ""
	echo "TCP connections on ${server_name}: "
    echo ""
	cat  /proc/net/tcp | wc -l
    echo ""
}

function kernel_check() {
    echo ""
	echo "Kernel version on ${server_name} is: "
	echo ""
	uname -r
    echo ""
}

function all_checks() {
	memory_check
	cpu_check
	tcp_check
	kernel_check
}
function deleteServer() {
    ls /etc/nginx/sites-enabled/
    read -p 'Dominio: ' dominioToDelete
    rm /etc/nginx/sites-enabled/${dominioToDelete} >/dev/null 2>&1
    rm /etc/nginx/sites-available/${dominioToDelete} >/dev/null 2>&1
    service nginx restart
}

function createServer() {
	# 1. PIDE DATOS 
	read -p 'Dominio: ' dominio
	if [ -z $dominio ]; then exit 0; fi
	read -p 'IP local: ' ip
	if [ -z $ip ]; then exit 0; fi
	read -p 'Puerto: ' puerto
	if [ $puerto ]; then  puerto=:$puerto; fi

	# 2. DESCARGA TEMPLATE
	wget -O ${dominio}.conf https://raw.githubusercontent.com/manviny/BASH/main/nginx80.tmpl >/dev/null 2>&1

	# 3. REEMPLAZA POR LOS VALORES DEL NUEVO SERVIDOR
	sed -i "s/__DOMINIO/$dominio/" ${dominio}.conf 
	sed -i "s/__IP/$ip/" ${dominio}.conf 
	sed -i "s/__PUERTO/$puerto/" ${dominio}.conf 

	# 4. HABILITA EL NUEVO SERVIDOR
	mv ./${dominio}.conf /etc/nginx/sites-available
	ln -s /etc/nginx/sites-available/${dominio}.conf /etc/nginx/sites-enabled/
	service nginx restart

	# 5. MUESTRA SERVIDOR CREADO
	echo Servidor Activo 
	ls /etc/nginx/sites-enabled/${dominio}*
}

##
# Color  Variables
##
green='\e[32m'
blue='\e[34m'
clear='\e[0m'

##
# Color Functions
##

ColorGreen(){
	echo -ne $green$1$clear
}
ColorBlue(){
	echo -ne $blue$1$clear
}

menu(){
echo -ne "
My First Menu
$(ColorGreen '1)') Memory usage
$(ColorGreen '2)') CPU load
$(ColorGreen '3)') Number of TCP connections 
$(ColorGreen '4)') Kernel version
$(ColorGreen '5)') Check All
$(ColorGreen '6)') Create Server
$(ColorGreen '7)') Delete Server
$(ColorGreen '0)') Exit
$(ColorBlue 'Choose an option:') "
        read a
        case $a in
	        1) memory_check ; menu ;;
	        2) cpu_check ; menu ;;
	        3) tcp_check ; menu ;;
	        4) kernel_check ; menu ;;
	        5) all_checks ; menu ;;
	        6) createServer ; menu ;;
	        7) deleteServer ; menu ;;
		0) exit 0 ;;
		*) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}

# Call the menu function
menu
