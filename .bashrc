
MY_HOME='/c/JGARAY'
MY_CONFIG='$MY_HOME/Config'
MY_WORK='$MY_HOME/Proyectos'
for DOTFILE in `find $MY_CONFIG/dotfiles`
do
  [ -f “$DOTFILE” ] && source “$DOTFILE”
done