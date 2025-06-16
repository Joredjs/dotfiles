#!/usr/bin/env bash
# Bash functions configuration

echo "Loading functions configuration..."

# Create directory and enter it
##Uso: $ mkcd {nombreCarpeta}
mkcd() {
	mkdir -p "$@" && cd "$_" || return
}

# Create a temporary directory and enter it
##Uso: $ mkcd {nombreCarpeta/nombreArchivo (opcional)}
tmpd() {
	local dir
	if [ $# -eq 0 ]; then
		dir=$(mktemp -d)
	else
		dir=$(mktemp -d -t "${1}.XXXXXXXXXX")
	fi
	cd "$dir" || return
	echo "Created and entered temporary directory: $dir"
}

# Extract various archive formats
extract() {
	if [ -f "$1" ]; then
		case $1 in
		*.tar.bz2) tar xjf "$1" ;;
		*.tar.gz) tar xzf "$1" ;;
		*.bz2) bunzip2 "$1" ;;
		*.rar) unrar e "$1" ;;
		*.gz) gunzip "$1" ;;
		*.tar) tar xf "$1" ;;
		*.tbz2) tar xjf "$1" ;;
		*.tgz) tar xzf "$1" ;;
		*.zip) unzip "$1" ;;
		*.Z) uncompress "$1" ;;
		*.7z) 7z x "$1" ;;
		*) echo "'$1' cannot be extracted via extract()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

# Create a backup of a file
backup() {
	if [ -f "$1" ]; then
		cp "$1" "${1}.$(date +%Y%m%d_%H%M%S).backup"
		echo "Backup created: ${1}.$(date +%Y%m%d_%H%M%S).backup"
	else
		echo "File not found: $1"
	fi
}

# Find files by name
ff() {
	find . -type f -iname "*$*" 2>/dev/null
}

# Find directories by name
fd() {
	find . -type d -iname "*$*" 2>/dev/null
}

# Get file size in human readable format
sizeof() {
	if du -b /dev/null >/dev/null 2>&1; then
		local arg=-sbh
	else
		local arg=-sh
	fi

	if [[ -n "$*" ]]; then
		du $arg -- "$@"
	else
		du $arg .[^.]* ./*
	fi
}

# Git functions
# -------------

# Git add all and commit
##Uso: $ gac 'mensaje'
gac() {
	if [ $# -eq 0 ]; then
		echo "Usage: gac 'commit message'"
		return 1
	fi
	git add -A && git commit -m "$*"
}

# Git add all, commit, and push
gacp() {
	if [ $# -eq 0 ]; then
		echo "Usage: gacp 'commit message'"
		return 1
	fi
	git add -A && git commit -m "$*" && git push
}

##Uso: $ gco {rama}
gco() { git checkout "$1"; }

##Uso: $ gcb {rama}
gcb() { git checkout -b "$1"; }

##Uso: $ gdf {parameters of gitdiff}
gdf() {
	if [ $# -eq 0 ]; then
		git diff --shortstat && git diff --compact-summary
	else
		git diff --shortstat "$*" && git diff --compact-summary "$*"
	fi
}

##Uso: $ gdft {branch} {path}
gdft() {
	if [ $# -eq 0 ]; then
		git difftool
	else
		git difftool "$*"
	fi
}

# Show git log in pretty format
glog() {
	git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit "$@"
}

# Remove git branches that have been merged
# gclean() {
#     echo "Branches merged into main/master:"
#     git branch --merged | grep -v "\*\|main\|master" | sed 's/^/  /'

#     read -p "Delete these branches? [y/N] " -n 1 -r
#     echo
#     if [[ $REPLY =~ ^[Yy]$ ]]; then
#         git branch --merged | grep -v "\*\|main\|master" | xargs -n 1 git branch -d
#     fi
# }

# System functions
# ----------------

# Show top processes by CPU
topcpu() {
	ps aux | head -1
	ps aux | grep -v "^USER" | sort -nrk 3 | head -"${1:-10}"
}

# Show top processes by memory
topmem() {
	ps aux | head -1
	ps aux | grep -v "^USER" | sort -nrk 4 | head -"${1:-10}"
}

# Get public IP with location info
myip() {
	echo "Public IP: $(curl -s https://api.ipify.org)"
	curl -s "https://ipapi.co/$(curl -s https://api.ipify.org)/json/" |
		jq -r '. | "Location: \(.city), \(.region), \(.country_name)"' 2>/dev/null ||
		echo "Location info not available"
}

# Development functions
# --------------------

# Create a data URL from a file
# dataurl() {
#     local mimeType=$(file -b --mime-type "$1")
#     if [[ $mimeType == text/* ]]; then
#         mimeType="${mimeType};charset=utf-8"
#     fi
#     echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
# }

# Create a random password
genpass() {
	local length="${1:-20}"
	LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*()_+' </dev/urandom | head -c "$length" && echo
}

# Show colors available in terminal
colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	for fgc in {30..37}; do
		for bgc in {40..47}; do
			fgc=${fgc#37}
			bgc=${bgc#40}
			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}
			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo
		echo
	done
}

echo "Functions configuration loaded successfully."
