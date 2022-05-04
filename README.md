# DOTFILES

Configuración general para la configuración de los dotfiles, las configuraciones especificas de cada pc, estará en su propia rama

```bash
git branch -al
```

Puedes hacer la configuración de tus dotfiles de dos formas, ejecutando el script ***myDotFiles.sh*** (recomendado) o realizar la configuracion de forma manual (no recomendado).

## Configuración Manual

1. Debes definir y crear tu carpeta personal dentro de tu máquina, esta hace referencia a la variable ***MY_HOME*** dentro del archivo ***Home/.bashrc***, el valor de la variable debe ser el mismo a la ruta de esta carpeta
2. Dentro de la carpeta personal en tu máquina, debes copiar la carpeta Config que se encuentra en este repositorio
3. En tu carpeta home o raiz (***~***) debes copiar el contenido de la carpeta Home que se encuentra en este repositorio

## Ejecutando el script (**recomendado**)

1. Debes estar dentro de la carpeta ***dotfiles*** que hace referencia a la carpeta raiz de este repo
2. Debes cambiar el valor de la variable ***MY_HOME*** dentro del archivo ***Home/.bashrc***, esta hace referencia a tu carpeta personal dentro de tu máquina, el valor de la variable debe ser el mismo a la ruta de esta carpeta
3. Si los archivos dentro de tu carpeta home (***~***) ya existen, por seguridad se deben modificar manualmente

```bash
gh repo clone Joredjs/dotfiles
cd dotfiles
. myDotFiles.sh
```

## Configuración

Puedes agregar tu configuración personal dentro de ***Home/.bashrc*** con la información personalizada. Lo ideal es cambiar los valores pero mantener el nombre de las variables que aparecen en el, si realizas un cambio sobre los nombres de estas, recuerda verificar los siguientes archivos para evitar errores:

- ***Config/dotfiles/.alias***
- ***Config/dotfiles/.help***
- ***Config/dotfiles/bin/.bash_profile***
- ***Config/dotfiles/bin/.bashrc***

y dentro del script ***myDotFiles.sh***

### Configuración personalizada

> *Espacio para agregar la información personalizada de cada maquína a ser llenada en la rama correspondiente*

## Explicación dotfiles

***TODO: agregar explicación***
