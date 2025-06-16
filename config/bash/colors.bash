#!/usr/bin/env bash
# colors.bash - Color definitions and theme support
echo "Loading colors configuration..."

# Check if terminal supports colors
if ! tput setaf 1 &>/dev/null; then
	# Fallback ANSI colors for terminals without tput
	export BLACK='\033[0;30m'
	export RED='\033[0;31m'
	export GREEN='\033[0;32m'
	export YELLOW='\033[0;33m'
	export BLUE='\033[0;34m'
	export PURPLE='\033[0;35m'
	export CYAN='\033[0;36m'
	export WHITE='\033[0;37m'
	export ORANGE='\033[0;33m'
	export MAGENTA='\033[0;35m'
	export BOLD='\033[1m'
	export DIM='\033[2m'
	export UNDERLINE='\033[4m'
	export RESET='\033[0m'
else
	# Use tput for better terminal compatibility
	export BLACK=$(tput setaf 0)
	export RED=$(tput setaf 1)
	export GREEN=$(tput setaf 2)
	export YELLOW=$(tput setaf 3)
	export BLUE=$(tput setaf 4)
	export PURPLE=$(tput setaf 5)
	export CYAN=$(tput setaf 6)
	export WHITE=$(tput setaf 7)
	export ORANGE=$(tput setaf 208 2>/dev/null || tput setaf 3)
	export MAGENTA=$(tput setaf 141 2>/dev/null || tput setaf 5)
	export BOLD=$(tput bold)
	export DIM=$(tput dim)
	export UNDERLINE=$(tput smul)
	export RESET=$(tput sgr0)
fi

# Background colors
if tput setab 1 &>/dev/null; then
	export BG_BLACK=$(tput setab 0)
	export BG_RED=$(tput setab 1)
	export BG_GREEN=$(tput setab 2)
	export BG_YELLOW=$(tput setab 3)
	export BG_BLUE=$(tput setab 4)
	export BG_PURPLE=$(tput setab 5)
	export BG_CYAN=$(tput setab 6)
	export BG_WHITE=$(tput setab 7)
fi

# Theme-specific color assignments
case "${DOTFILES_THEME:-default}" in
"minimal")
	export PS1_USER_COLOR="$WHITE"
	export PS1_HOST_COLOR="$WHITE"
	export PS1_PATH_COLOR="$WHITE"
	export PS1_GIT_COLOR="$WHITE"
	export PS1_TIME_COLOR="$WHITE"
	export PS1_PROMPT_COLOR="$WHITE"
	;;
"dark")
	export PS1_USER_COLOR="$CYAN"
	export PS1_HOST_COLOR="$PURPLE"
	export PS1_PATH_COLOR="$BLUE"
	export PS1_GIT_COLOR="$MAGENTA"
	export PS1_TIME_COLOR="$YELLOW"
	export PS1_PROMPT_COLOR="$GREEN"
	;;
"light")
	export PS1_USER_COLOR="$BLUE"
	export PS1_HOST_COLOR="$GREEN"
	export PS1_PATH_COLOR="$PURPLE"
	export PS1_GIT_COLOR="$RED"
	export PS1_TIME_COLOR="$CYAN"
	export PS1_PROMPT_COLOR="$YELLOW"
	;;
"fancy")
	export PS1_USER_COLOR="$BOLD$GREEN"
	export PS1_HOST_COLOR="$BOLD$BLUE"
	export PS1_PATH_COLOR="$BOLD$CYAN"
	export PS1_GIT_COLOR="$BOLD$PURPLE"
	export PS1_TIME_COLOR="$BOLD$MAGENTA"
	export PS1_PROMPT_COLOR="$BOLD$ORANGE"
	;;
*)
	export PS1_USER_COLOR="$GREEN"
	export PS1_HOST_COLOR="$BLUE"
	export PS1_PATH_COLOR="$CYAN"
	export PS1_GIT_COLOR="$PURPLE"
	export PS1_TIME_COLOR="$MAGENTA"
	export PS1_PROMPT_COLOR="$ORANGE"
	;;
esac

# Git status colors
export GIT_STAGED_COLOR="$GREEN"
export GIT_MODIFIED_COLOR="$ORANGE"
export GIT_DELETED_COLOR="$RED"
export GIT_UNTRACKED_COLOR="$YELLOW"
export GIT_CLEAN_COLOR="$CYAN"

# # Function to display color palette
# show_colors() {
# 	echo "Available colors:"
# 	echo -e "${BLACK}BLACK${RESET} ${RED}RED${RESET} ${GREEN}GREEN${RESET} ${YELLOW}YELLOW${RESET}"
# 	echo -e "${BLUE}BLUE${RESET} ${PURPLE}PURPLE${RESET} ${CYAN}CYAN${RESET} ${WHITE}WHITE${RESET}"
# 	echo -e "${ORANGE}ORANGE${RESET} ${MAGENTA}MAGENTA${RESET}"
# 	echo
# 	echo "Text styles:"
# 	echo -e "${BOLD}BOLD${RESET} ${DIM}DIM${RESET} ${UNDERLINE}UNDERLINE${RESET}"
# 	echo
# 	echo "Current theme: ${DOTFILES_THEME:-default}"
# }

# # Function to test 256 color support
# show_256_colors() {
# 	if ! tput setaf 256 &>/dev/null; then
# 		echo "Terminal doesn't support 256 colors"
# 		return 1
# 	fi

# 	echo "256 Color Test:"
# 	for i in {0..255}; do
# 		printf "\033[48;5;%sm%3d" $i $i
# 		if ((i == 15)) || ((i > 15)) && (((i - 15) % 6 == 0)); then
# 			printf "\033[0m\n"
# 		fi
# 	done
# 	printf "\033[0m\n"
# }

# # Export functions
# export -f show_colors show_256_colors

# echo "Colors loaded successfully."
