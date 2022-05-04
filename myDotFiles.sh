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
				echo -e "\n... carpeta $1 ${action_txt}da correctamente ...\n"
				break
				;;
			[Nn][Oo] | [Nn])
				echo "... Ok, debes ${action_txt}rla manualmente o cambiar la configuración en tu dotfile para continuar!"
				return 1
				;;
			*)
				echo "... Por favor escribe 'si/s' o 'no/n' ..."
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

#El nombre de las variable creada en el archivo Home/.bashrc
var_home="MY_HOME"
var_config="MY_CONFIG"
var_work="MY_WORK"
var_personal="MY_PERSONAL"
var_proy="MY_PROJECTS_FOLDER"

#valores por defecto
config_home="~"
config_config="Config"
config_work="Work"
config_personal="Personal"
config_proy="Proyectos"


#TODO: crear funcion para poblar las variables por defecto
while read -r linea; do
	[[ $linea = *"$var_home="* ]] && config_home=$linea
	[[ $linea = *"$var_config="* ]] && config_config=$linea
	[[ $linea = *"$var_work="* ]] && config_work=$linea
	[[ $linea = *"$var_personal="* ]] && config_personal=$linea
	[[ $linea = *"$var_proy="* ]] && config_proy=$linea
done <Home/.bashrc

home_value=$(echo "$config_home" | cut -d "=" -f 2)
home_value="${home_value//\"/}"

config_value=$(echo "$config_config" | cut -d "=" -f 2)
config_value="${config_value//\"/}"
config_value=$(eval echo "${config_value}")

work_value=$(echo "$config_work" | cut -d "=" -f 2)
work_value="${work_value//\"/}"
work_value=$(eval echo "${work_value}")

personal_value=$(echo "$config_personal" | cut -d "=" -f 2)
personal_value="${personal_value//\"/}"
personal_value=$(eval echo "${personal_value}")

proy_value=$(echo "$config_proy" | cut -d "=" -f 2)
proy_value="${proy_value//\"/}"
proy_value=$(eval echo "${proy_value}")

#TODO: Crear la carpeta Keys

##Configuración inicial
while true; do
	read -rp "La ruta de tu carpeta inicial está configurada como ${home_value}/ ¿Es correcto? [si/no]: " resp_home
	case "$resp_home" in
	[Ss][Ii] | [Ss])
		echo -e "\n... Ok, recuerda que esta carpeta inical hace referencia a la variable '\${MY_HOME}' ...\n"
		break
		;;
	[Nn][Oo] | [Nn])
		echo "... Ok, configura tu archivo Home/.bashrc y vuelve a intentarlo!"
		return 1
		;;
	*)
		echo "... Por favor escribe 'si/s' o 'no/n' ..."
		;;
	esac
done

#Carpeta inicial
if ! foldersStuuf "$home_value"; then
	return
fi

#Carpeta Config
if ! foldersStuuf "$config_value" "Config"; then
	return
fi

#Carpeta Home
if [[ -z "$HOME" ]]; then
	HOME="~"
fi

while true; do
	echo -e "La ruta de la carpeta HOME(~) de tu equipo está configurada como ${HOME}/"
	read -rp "¿Es correcta para proceder a copiar los archivos correspondientes? [si/no]: " resp_home_so
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
					filename=$(date +%F_%T | tr -d '-' | tr -d ':')
					filename=${home_file}_${filename}

					echo -e "\n... El archivo $home_file ya existe por lo tanto se creara una copia '${filename}'  ..."
					mv $HOME/"$home_file" $HOME/"${filename}"
					echo -e "... Se ha generado el backup del archivo $home_file correctamente ..."
					cp Home/"$home_file" $HOME/
					echo -e "... El archivo $home_file se ha copiado correctamente en tu carpeta home ...\n"
				else
					cp Home/"$home_file" $HOME/
					echo -e "\n... El archivo $home_file se ha copiado correctamente en tu carpeta home ...\n"
				fi
			fi
		done < <(find "Home/")
		break
		;;
	[Nn][Oo] | [Nn])
		echo "... Ok, se recomienda hacer la copia manualmente de los archivos dentro de la carpeta Home/ a tu carpeta (~)"
		return 1
		;;
	*)
		echo "... Por favor escribe 'si/s' o 'no/n' ..."
		;;
	esac
done

#Separacion de ambientes work/life...
if foldersStuuf "${work_value}"; then
	foldersStuuf "${work_value}${proy_value}"
fi
if foldersStuuf "${personal_value}"; then
	foldersStuuf "${personal_value}${proy_value}"
fi

echo -e "\nListo!\n\n...El script se ha ejecutado correctamente...\n...por favor completa los pasos manuales (si es necsario) para terminar el proceso correctamente...\n...No olvides dejar tu feedback...\n...Ejecuta tu git-bash para ver la magia!!"
echo -e "\nADIOS!!"
