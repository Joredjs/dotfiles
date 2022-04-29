# dotfiles

my dotfiles configuration for Lenovo Laptop

## Configuración

Lo primero que debes hacer es configurar el archivo ***Home/.bashrc*** con la información de tu máquina. Lo ideal es cambiar los valores pero mantener el nombre de las variables que aparecen en el, si realizas un cambio sobre los nombres de estas, recuerda verificar los siguientes archivos para evitar errores:

- ***Config/dotfiles/.alias***
- ***Config/dotfiles/.help***
- ***Config/dotfiles/bin/.bash_profile***
- ***Config/dotfiles/bin/.bashrc***

## Home

Los archivos ubicados dentro de la carpeta *Home* se deben copiar dentro del home de tu equipo ( ***~/*** )

## Config

Los archivos dentro de la carpeta Config se deben copiar en la ruta ${MY_HOME}/Config que se configuraron dentro del archivo ***.bashrc*** de la carpeta *Home*

## script

Si no deseas hacerlo manualmente y confías en el repositorio puedes ejecutar el script ***myDotFiles.sh***
