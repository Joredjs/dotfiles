#!/bin/bash
#export GOPATH="/c/Archivos de programa/Go/bin/"

echo "- Hola $(whoami),"
#Con export quedan como variables globales
#Se deben nombrar como MY_* para que se listen en el comando de ayuda (f1)

#Se recomienda no modificar el nombre de la siguientes variable
#Si se modifica, verificar el script myDotFiles.sh
export MY_HOME="/c/JGARAY"

#Si se modifican los nombres de las variables o se crean nuevas, verificar el archivo Config/dotfiles/.alias
export MY_WORK="${MY_HOME}/Proyectos"
export MY_KEYS="${MY_HOME}/Keys"

#Ubicacion de los .files
#Se recomienda no modificar los nombres de las siguientes variables
#si se modifican verificar los archivos dentro de Config/dotfiles/.help Config/dotfiles/bin/*
export MY_CONFIG="${MY_HOME}/Config"
export MY_DOTFILES="${MY_CONFIG}/dotfiles"
export MY_BIN="${MY_DOTFILES}/bin"

source ${MY_BIN}"/.bash_profile"
