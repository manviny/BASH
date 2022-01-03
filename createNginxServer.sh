#!/bin/bash 

# EJECUTAR DESDE EL TERMINAL DEL SERVIDOR NGINX EN PROXMOX
# wget -O - https://raw.githubusercontent.com/manviny/BASH/main/createNginxServer.sh | sudo bash

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
