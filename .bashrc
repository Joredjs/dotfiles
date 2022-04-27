#!/bin/bash
export GOPATH="/c/Archivos de programa/Go/bin/"


echo "- Hola $(whoami),"
#Con export quedan como variables globales
#Se deben nombrar como MY_* para que se listen en el comando de ayuda (f1)
export MY_HOME="/c/JGARAY"
export MY_WORK="${MY_HOME}/Proyectos"
export MY_KEYS="${MY_HOME}/Keys"
#Ubicacion de los .files
export MY_CONFIG="${MY_HOME}/Config"
export MY_DOTFILES="${MY_CONFIG}/dotfiles"
export MY_BIN="${MY_DOTFILES}/bin"

source ${MY_BIN}"/.bash_profile"
