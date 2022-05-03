#!/bin/bash
while IFS= read -r DOTFILE; do
    skip=0
    if [[ ($DOTFILE == *".md"*) || ($DOTFILE == *"bin"*) ]]; then
        skip=1
    fi

    ejec=0
    if [[ $DOTFILE == *"."* ]]; then
        ejec=1
    fi

    if [[ ($skip == 0) && ($ejec == 1) ]]; then
        [ -f "$DOTFILE" ] && source "$DOTFILE"
    fi
done < <(find "${MY_CONFIG}/dotfiles/")

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob
# Append to the Bash history file, rather than overwriting it
shopt -s histappend
# Autocorrect typos in path names when using `cd`
shopt -s cdspell
# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
    shopt -s "$option" 2>/dev/null
done
