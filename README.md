# BASH

## 1. Conectarse al nodo principal de PROXMOX
Desde el terminal conectarse al nodo que nos interese, por ejemplo a un Contenedor con Dedian y NGINX en el nodo 100
```
# para ver los nodos
pct list
# para conectarnos a uno de los nodos
pce enter 100


## 2. Descargar el Script para crear servidores desde el servidor NGINX de PROXMOX con nº de nodo 100
```
wget -O createNginxServer.sh https://raw.githubusercontent.com/manviny/BASH/main/createNginxServer.sh && chmod +x createNginxServer.sh && ./createNginxServer.sh
 
