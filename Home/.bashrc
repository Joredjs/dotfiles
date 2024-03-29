#!/bin/bash

echo "- Hola $(whoami),"
#Con export quedan como variables globales
#Se deben nombrar como MY_* para que se listen en el comando de ayuda (f1)

#Se recomienda no modificar el nombre de la siguiente variable
#Si se modifica el nombre, verificar el script myDotFiles.sh
export MY_HOME="/c/JGARAY"

#Si se modifican los nombres de las variables o se crean nuevas, verificar el archivo Config/dotfiles/.alias
export MY_WORK="${MY_HOME}/Work"
export MY_PERSONAL="${MY_HOME}/Personal"
export MY_KEYS="${MY_HOME}/Keys"
export MY_PROJECTS_FOLDER="/Proyectos"

#Ubicacion de los .files
#Se recomienda no modificar los nombres de las siguientes variables
#si se modifican verificar los archivos dentro de Config/dotfiles/.help Config/dotfiles/bin/*
export MY_CONFIG="${MY_HOME}/Config"
export MY_DOTFILES="${MY_CONFIG}/dotfiles"
export MY_BIN="${MY_DOTFILES}/bin"

#variable de scoop
#Es necesario tener instalado scoop previamente
#si se modifica el nombre de esta variable, verificar la configuracion del archivo settings.json de tu vscode
export MY_SCOOP="${HOME}/scoop"

source ${MY_BIN}"/.bash_profile"
