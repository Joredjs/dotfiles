#!/usr/bin/env bash
# ~/.bashrc: executed by bash(1) for non-login shells.
echo "Initializing dotfiles ... $(date +%T)"

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# Error handling function
dotfiles_error() {
	echo "[DOTFILES ERROR] $1" >&2
}

DOTFILES_CONFIG="${HOME}/.config/dotfiles.conf"
if [[ -f "$DOTFILES_CONFIG" ]]; then
	source "$DOTFILES_CONFIG"
else
	dotfiles_error "Config file not found: $DOTFILES_CONFIG"
	dotfiles_error "Run the install script first or create the config manually"
fi

# Dotfiles locations
export MY_DOTFILES="${HOME}/.config/bash"
export MY_BIN="${HOME}/.local/bin"

# Package managers paths
case "$OS" in
linux)
	export MY_PACKAGE_PATH="${HOME}/.local"
	;;
macos)
	export MY_PACKAGE_PATH="/opt/homebrew"
	;;
windows)
	export MY_PACKAGE_PATH="${HOME}/scoop"
	;;
esac

# Set config directory based on XDG or fallback
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export BASH_CONFIG_DIR="${XDG_CONFIG_HOME}/bash"

# Load modular bash configurations
load_bash_config() {
	local config_dir="${BASH_CONFIG_DIR}"

	# If config dir doesn't exist, try legacy location
	if [[ ! -d "$config_dir" ]]; then
		dotfiles_error "Bash config directory not found: $config_dir"
		return 1
	fi

	# Features to load (order matters)
	local features=(
		"colors"
		"aliases"
		"functions"
		"prompt"
		"help"
	)

	# Load enabled features
	for feature in "${features[@]}"; do
		local file="${config_dir}/${feature}.bash"
		if [[ -f "$file" ]]; then
			source "$file"
		fi
	done

	# Load OS-specific configuration
	local os_config="${config_dir}/${OS_TYPE}.bash"
	[[ -f "$os_config" ]] && source "$os_config" 2>/dev/null

	# Load local/private configuration
	local local_config="${config_dir}/local.bash"
	[[ -f "$local_config" ]] && source "$local_config" 2>/dev/null

	return 0
}

# Shell options
set_shell_options() {
	# Default options
	local default_options="nocaseglob histappend cdspell"

	# Use configured options or defaults
	local options="${SHELL_OPTIONS:-$default_options}"

	# Apply each option
	for option in $options; do
		if ! shopt -s "$option" 2>/dev/null; then
			dotfiles_error "Invalid shell option: $option"
		fi
	done
}

# History configuration
configure_history() {
	export HISTCONTROL=ignoreboth:erasedups
	export HISTSIZE=10000
	export HISTFILESIZE=20000
	export HISTTIMEFORMAT="%F %T "

	# Create history file if it doesn't exist
	touch ~/.bash_history 2>/dev/null || dotfiles_error "Cannot create history file"

	# Append to history immediately
	export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
}

# Welcome message
show_welcome() {

	echo "Welcome $(whoami)!"
	echo "OS: $OS | Shell: $BASH_VERSION"

	# Show dotfiles version if in git repo
	if command -v git &>/dev/null && [[ -d "${HOME}/.config/.git" ]]; then
		local version
		version=$(cd "${HOME}/.config" && git describe --tags --always 2>/dev/null)
		[[ -n "$version" ]] && echo "Dotfiles: $version"
	fi

	# Show any configuration warnings
	if [[ "$MY_FOLDER_PATH" == "$HOME" ]]; then
		echo "Warning: Using default MY_FOLDER_PATH. Configure in ~/.config/bash/dotfiles.conf"
	fi

}

# Initialize everything
main() {
	local init_errors=0

	set_shell_options || ((init_errors++))
	configure_history || ((init_errors++))
	# configure_path || ((init_errors++))

	if ! load_bash_config; then
		((init_errors++))
		echo "Basic shell initialized with errors. Run install script to complete setup."
	fi

	show_welcome

	if [[ $init_errors -gt 0 ]]; then
		echo "Initialization completed with $init_errors error(s). Check messages above."
	fi
}

# Run initialization
main

# Cleanup
unset -f main load_bash_config set_shell_options configure_history show_welcome dotfiles_error


# Load Angular CLI autocompletion.
source <(ng completion script)

echo "dotfiles loaded. $(date +%T)"
