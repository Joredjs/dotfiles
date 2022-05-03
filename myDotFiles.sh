#!/bin/bash

#funcion para crear/copiar las carpetas
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

#funcion para editar la configuración
editarInfo() {
  if [[ -n "$1" ]]; then
    while true; do
      read -rp "Deseas cambiar la información dentro del archivo ${1}? [si/no]: " resp_editar 0</dev/tty
      case "$resp_editar" in
      [Ss][Ii] | [Ss])
        #cambiar información
        echo -e "... Recuerda cerrar el editor de texto luego de cambiar la información para poder continuar con el proceso ..."
        "${1}" | code -wr
        break
        ;;
      [Nn][Oo] | [Nn])
        echo "... Ok!!"
        break
        ;;
      *)
        echo "... Por favor escribe 'si/s' o 'no/n' aca ..."
        ;;
      esac
    done
  fi
}

#validacion de ubicacion del archivo
parent_folder=$(pwd | rev | cut -d "/" -f 1 | rev)
if [[ "$parent_folder" != "dotfiles" || ! -d "$(pwd)/Home" || ! -d "$(pwd)/Config" ]]; then
  echo "Verifica que te encuentres dentro de la carpeta adecuada y vuelve a intentarlo"
  return 1
fi

#El nombre de la variable creada en el archivo Home/.bashrc
var_home="MY_HOME"
config_home="~"

while read -r linea; do
  [[ $linea = *"$var_home="* ]] && config_home=$linea
done <Home/.bashrc

home_value=$(echo "$config_home" | cut -d "=" -f 2)
home_value="${home_value//\"/}"

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

#Carpeta Home
if [[ -z "$HOME" ]]; then
  HOME="~"
fi

while true; do
  read -rp "La ruta de la carpeta HOME de tu eqipo está configurada como ${HOME}/ ¿Es correcta para proceder a copiar los archivos correspondientes? [si/no]: " resp_home_so
  case "$resp_home_so" in
  [Ss][Ii] | [Ss])
    while IFS= read -r home_path_file; do
      home_file=$(echo "$home_path_file" | rev | cut -d "/" -f 1 | rev)
      if [[ -d "$HOME/$home_file" ]]; then
        if [[ -n "$home_file" ]]; then
          echo -e "\n... $home_file es un directorio ...\n"
        fi
      else
        if [[ -f "$HOME/$home_file" ]]; then
          echo -e "\n... El archivo $home_file ya existe por lo tanto NO se copiará, por seguridad se recomienda copiarlo manualmente  ..."
          #TODO: poder cambiar la info con vscode (o cualquier otro) utilizando el flag wait
          #editarInfo "$HOME/$home_file"
        else
          cp Home/"$home_file" $HOME/
          echo -e "\n... El archivo $home_file se ha copiado correctamente en tu carpeta home ..."
        fi
      fi
    done < <(find "Home/")
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