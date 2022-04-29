#!/bin/bash

#funcion para crear/editar las carpetas
##$1:path
##$2:copy path

foldersStuuf() {
  action_txt='crea'
  action_cmd='mkdir -p'
  if [[ -n "$2" ]]; then
    action_txt='copia'
    action_cmd="cp -r $2"
  fi

  if [[ ! -d "$1" ]]; then
    while true; do
      read -rp "La carpeta $1 no existe. ¿Deseas ${action_txt}rla? [si/no]: " resp_folder
      case "$resp_folder" in
      [Ss][Ii] | [Ss])
        eval "$action_cmd $1"
        echo "... carpeta $1 ${action_txt}da correctamente ..."
        break
        ;;
      [Nn][Oo] | [Nn])
        echo "... Ok, debes ${action_txt}rla manualmente o cambiar la configuración en tu dotfile para continuar!"
        exit
        ;;
      *)
        echo "... Por favor escribe 'si/s' o 'no/n' ..."
        ;;
      esac
    done
  fi
}

#El nombre de la variable creada en el archivo Home/.bashrc
var_home="MY_HOME"
config_home="~"

while read -r linea; do
  [[ $linea = *"$var_home="* ]] && config_home=$linea
done <Home/.bashrc

home_value=$(echo "$config_home" | cut -d "=" -f 2)
home_value="${home_value//\"/}"

#echo "$home_value"
#echo "$config_home"

##Configuración personal
while true; do
  read -rp "La ruta de tu carpeta personal está configurada como ${home_value}/ ¿Es correcta para continuar? [si/no]: " resp_home
  case "$resp_home" in
  [Ss][Ii] | [Ss])
    break
    ;;
  [Nn][Oo] | [Nn])
    echo "... Ok, configura tu archivo Home/.bashrc y vuelve a intentarlo!"
    exit
    ;;
  *)
    echo "... Por favor escribe 'si/s' o 'no/n' ..."
    ;;
  esac
done

#Carpeta personal
foldersStuuf "$home_value"
#Carpeta Config
foldersStuuf "$home_value/Config" "Config"

if [[ -z "$HOME" ]]; then
  HOME="~"
fi

#Carpeta Home
while true; do
  read -rp "La ruta de tu carpeta HOME de tu eqipo está configurada como ${HOME}/ ¿Es correcta para proceder a copiar los archivos correspondientes? [si/no]: " resp_home_so
  case "$resp_home_so" in
  [Ss][Ii] | [Ss])
    txtSalida="...\n"
    while IFS= read -r home_path_file; do
      home_file=$(echo "$home_path_file" | rev | cut -d "/" -f 1 | rev)
      #echo "$home_file"
      if [[ -d "$HOME/$home_file" ]]; then
        if [[ -n "$home_file" ]]; then
          txtSalida+="... $home_file es un directorio ...\n"
        fi
      else
        if [[ -f "$HOME/$home_file" ]]; then
          txtSalida+="... El archivo $home_file ya existe por lo tanto no se copiara, por seguridad se recomienda copiarlo manualmente  ...\n"
        else
          cp Home/"$home_file" $HOME/
          txtSalida+="... El archivo $home_file se ha copiado correctamente en tu carpeta home ...\n"
        fi
      fi
    done < <(find "Home/")
    txtSalida+="...\n"
    echo -e $txtSalida
    break
    ;;
  [Nn][Oo] | [Nn])
    echo "... Ok, se recomienda hacer la copia manualmente!"
    exit
    ;;
  *)
    echo "... Por favor escribe 'si/s' o 'no/n' ..."
    ;;
  esac
done

echo "Listo!! el script se ha ejecutado correctamente, por favor completa los pasos manuales (si quedaron) para terminar el proceso satisfactoriamente"
echo -e "\nADIOS!!"
