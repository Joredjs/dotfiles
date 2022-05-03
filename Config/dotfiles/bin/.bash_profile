#!/bin/bash
#Deben estar configuradas las variables globales en el archivo .bashrc por defecto (~/.bashrc)
p1=true
p2=true
test -f "${MY_BIN}"/.profile && . "${MY_BIN}"/.profile || p1=false
test -f "${MY_BIN}"/.bashrc && . "${MY_BIN}"/.bashrc || p2=false

if ($p1 || $p2); then
    echo -e "- Configuración cargada!!\nPara ayuda ejecuta el comando 'f1'"
else
    echo -e "ERROR: No se puede cargar la configuración\nVerifica tus variables en ~/.bashrc y que los archivos de configuración de tus .files existan"
fi