#!/usr/bin/env bash
set -uo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
# PURPLE='\033[0;35m'
WHITE='\033[0;37m'
NC='\033[0m' # No Color

# Global variables
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${HOME}/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
DOTFILES_CONF_NAME="dotfiles.conf"
CONFIG_FILE="${DOTFILES_DIR}/config/${DOTFILES_CONF_NAME}"
CONFIG_TEMPLATE="${DOTFILES_DIR}/config/${DOTFILES_CONF_NAME}.template"

ERRORS_OCCURRED=0
DRY_RUN=false

# Utility functions
log_info() {
	echo -e "${WHITE}[INFO]${NC} $*"
}

log_warn() {
	echo -e "${YELLOW}[WARN]${NC} $*"
}

log_error() {
	echo -e "${RED}[ERROR]${NC} $*" >&2
	ERRORS_OCCURRED=1
}

log_step() {
	echo -e "${BLUE}[STEP]${NC} $*"
}

log_success() {
	echo -e "${GREEN}[SUCCESS]${NC} $*"
}

# Detect OS
detect_os() {
	case "$(uname -s)" in
	Linux*) OS='Linux' ;;
	Darwin*) OS='Mac' ;;
	MINGW* | MSYS* | CYGWIN*) OS='Windows' ;;
	*) OS='Unknown' ;;
	esac
	export OS
}

# Configuration wizard
setup_configuration() {
	log_step "Setting up dotfiles configuration..."

	# Default values
	local my_folder="MY_FOLDER"
	local my_work_folder="MY_WORK_FOLDER"
	local my_personal_folder="MY_PERSONAL_FOLDER"
	local my_keys_folder="MY_KEYS_FOLDER"
	local editor="vim"
	local visual="vim"
	local diff_tool="vimdiff"
	local merge_tool="vimdiff"
	local git_name=""
	local git_email=""

	# Detect better defaults based on OS
	case "$OS" in
	Windows)
		if command -v code &>/dev/null; then
			editor="code"
			visual="code"
			diff_tool="code"
			merge_tool="code"
		fi
		;;
	Mac)
		if command -v code &>/dev/null; then
			editor="code"
			visual="code"
			diff_tool="code"
			merge_tool="code"
		elif command -v nvim &>/dev/null; then
			editor="nvim"
			visual="nvim"
		fi
		;;
	Linux)
		if command -v nvim &>/dev/null; then
			editor="nvim"
			visual="nvim"
		elif command -v nano &>/dev/null; then
			editor="nano"
			visual="nano"
		fi
		;;
	esac

	echo
	echo "Let's configure your dotfiles. Press Enter to use defaults shown in [brackets]."
	echo

	# Get user input
	read -rp "Enter the directory where you will organize all your stuff [$my_folder]: " my_folder
	my_folder="${my_folder:-"MY_DIRECTORY"}"

	read -rp "Enter your Work directory [$my_work_folder]: " my_work_folder
	my_work_folder="${my_work_folder:-"MY_WORK_DIRECTORY"}"

	read -rp "Enter your Personal projects directory [$my_personal_folder]: " my_personal_folder
	my_personal_folder="${my_personal_folder:-"MY_PERSONAL_DIRECTORY"}"

	read -rp "Enter your Keys/credentials directory [$my_keys_folder]: " my_keys_folder
	my_keys_folder="${my_keys_folder:-"MY_KEYS_DIRECTORY"}"

	read -rp "Preferred editor [$editor]: " input_editor
	editor="${input_editor:-$editor}"

	read -rp "Visual editor [$visual]: " input_visual
	visual="${input_visual:-$visual}"

	read -rp "Diff tool [$diff_tool]: " input_diff
	diff_tool="${input_diff:-$diff_tool}"

	read -rp "Merge tool [$merge_tool]: " input_merge
	merge_tool="${input_merge:-$merge_tool}"

	echo
	echo "Git configuration (optional):"
	read -rp "Git user name: " git_name
	read -rp "Git email: " git_email

	# Validate and create directories
	my_folder_path="$HOME/$my_folder"
	if [[ ! -d "$my_folder_path" ]]; then
		read -rp "Directory $my_folder_path doesn't exist. Create it? [y/N]: " create_dir
		if [[ "$create_dir" =~ ^[Yy]$ ]]; then
			mkdir -p "$my_folder_path" || {
				log_error "Failed to create directory: $my_folder_path"
				return 1
			}
		else
			log_warn "Using $HOME instead of $my_folder"
			my_folder_path="$HOME"
		fi
	fi

	# Generate configuration file
	if [[ ! -f "$CONFIG_TEMPLATE" ]]; then
		log_error "Configuration template not found: $CONFIG_TEMPLATE"
		return 1
	fi

	mkdir -p "$(dirname "$CONFIG_FILE")"

	# Replace placeholders in template
	sed -e "s|{{MY_FOLDER_PATH}}|$my_folder_path|g" \
		-e "s|{{MY_WORK_FOLDER}}|$my_work_folder|g" \
		-e "s|{{MY_WORK_FOLDER_PATH}}|$my_folder_path/$my_work_folder|g" \
		-e "s|{{MY_PERSONAL_FOLDER}}|$my_personal_folder|g" \
		-e "s|{{MY_PERSONAL_FOLDER_PATH}}|$my_folder_path/$my_personal_folder|g" \
		-e "s|{{MY_KEYS_FOLDER}}|$my_keys_folder|g" \
		-e "s|{{MY_KEYS_FOLDER_PATH}}|$my_folder_path/$my_keys_folder|g" \
		-e "s|{{EDITOR}}|$editor|g" \
		-e "s|{{VISUAL}}|$visual|g" \
		-e "s|{{DIFF_TOOL}}|$diff_tool|g" \
		-e "s|{{MERGE_TOOL}}|$merge_tool|g" \
		-e "s|{{GIT_USER_NAME}}|$git_name|g" \
		-e "s|{{GIT_USER_EMAIL}}|$git_email|g" \
		"$CONFIG_TEMPLATE" >"$CONFIG_FILE"

	log_success "Configuration created: $CONFIG_FILE"
	return 0
}

# Load configuration
load_config() {
	if [[ -f "$CONFIG_FILE" ]]; then
		# shellcheck source=/dev/null
		source "$CONFIG_FILE"

		# Validate critical variables
		if [[ -z "${MY_FOLDER_PATH:-}" ]]; then
			log_error "MY_FOLDER_PATH not set in configuration"
			return 1
		fi

		# Check for template placeholders
		if grep -q "{{.*}}" "$CONFIG_FILE"; then
			log_warn "Configuration contains template placeholders. Regenerating..."
			return 1
		fi

		return 0
	else
		log_info "No configuration found. Starting setup wizard..."
		return 1
	fi
}

# Create directory structure
create_directory_structure() {
	local dir="$1"

	if [[ "$DRY_RUN" == true ]]; then
		log_info "[DRY RUN] Would create directory: $dir"
		return 0
	fi

	echo "Creating directory: $dir"

	if [[ ! -d "$dir" ]]; then
		read -rp "Directory $dir doesn't exist. Create it? [y/N]: " response
		case "$response" in
		[Yy]*)
			mkdir -p "$dir" || {
				log_error "Failed to create directory: $dir"
				return 1
			}
			log_info "Created directory: $dir"
			;;
		*)
			log_warn "Skipping directory creation: $dir"
			return 1
			;;
		esac
	fi
}

# Backup existing files
backup_file() {
	local file="$1"

	if [[ "$DRY_RUN" == true ]]; then
		log_info "[DRY RUN] Would backup: $file"
		return 0
	fi

	if [[ -e "$file" ]]; then
		mkdir -p "$BACKUP_DIR"
		local backup_file
		backup_file="${BACKUP_DIR}/$(basename "$file").$(date +%s)"
		cp -r "$file" "$backup_file"
		log_info "Backed up: $file -> $backup_file"
	fi
}

# Create symlink safely
create_symlink() {
	local source="$1"
	local target="$2"

	if [[ "$DRY_RUN" == true ]]; then
		log_info "[DRY RUN] Would link: $source -> $target"
		return 0
	fi

	# Create parent directory
	mkdir -p "$(dirname "$target")"

	# Backup if exists and not a symlink
	if [[ -e "$target" && ! -L "$target" ]]; then
		backup_file "$target"
		rm -rf "$target"
	fi

	# Create symlink
	if ln -sf "$source" "$target"; then
		log_info "Linked: $source -> $target"
	else
		log_error "Failed to create symlink: $source -> $target"
		return 1
	fi
}

# Install home dotfiles
install_home_dotfiles() {
	log_step "Installing home dotfiles..."

	# Use find to get all files (hidden and normal)
	find "${DOTFILES_DIR}/home" -maxdepth 1 -type f -exec basename {} \; | while read -r filename; do
		create_symlink "${DOTFILES_DIR}/home/${filename}" "${HOME}/${filename}"
	done
}

# Install config dotfiles
install_config_dotfiles() {
	log_step "Installing XDG config files..."

	# Create .config directory
	mkdir -p "${HOME}/.config"

	# Symlink each subdirectory in config/
	for config_dir in "${DOTFILES_DIR}/config"/*; do
		if [[ -d "$config_dir" ]]; then
			local dir_name
			dir_name=$(basename "$config_dir")
			# Skip the dotfiles.conf.template file
			if [[ "$dir_name" != "${DOTFILES_CONF_NAME}.template" ]]; then
				create_symlink "$config_dir" "${HOME}/.config/${dir_name}"
			fi
		else
			local file_name
			file_name=$(basename "$config_dir")
			## linking the created dotfiles.conf
			if [[ "$file_name" == "${DOTFILES_CONF_NAME}" ]]; then
				create_symlink "$config_dir" "${HOME}/.config/${file_name}"
			fi
		fi

	done
}

# Install work structure
install_work_structure() {
	log_step "Setting up work directory structure..."

	# Load config variables
	local base_dir="${MY_FOLDER_PATH:-}"

	echo "Using base directory: $base_dir"

	# Create main directories
	local dirs=(
		"${MY_WORK_FOLDER_PATH:-$base_dir/Work}"
		"${MY_PERSONAL_FOLDER_PATH:-$base_dir/Personal}"
		"${MY_KEYS_FOLDER_PATH:-$base_dir/Keys}"
	)

	for dir in "${dirs[@]}"; do

		create_directory_structure "$dir"
	done
}

link_editorconfig() {
	log_step "Linking editor configuration..."

	# Check if editor config exists
	if [[ -f "${DOTFILES_DIR}/home/.editorconfig" ]]; then
		create_symlink "${DOTFILES_DIR}/home/.editorconfig" "${HOME}/.editorconfig"
	else
		log_warn "Editor configuration file not found: ${DOTFILES_DIR}/home/.editorconfig"
	fi

}

# Setup package manager
setup_package_manager() {
	case "$OS" in
	Linux)
		if command -v apt-get &>/dev/null; then
			PACKAGE_MANAGER="apt"
		elif command -v dnf &>/dev/null; then
			PACKAGE_MANAGER="dnf"
		elif command -v pacman &>/dev/null; then
			PACKAGE_MANAGER="pacman"
		elif command -v zypper &>/dev/null; then
			PACKAGE_MANAGER="zypper"
		fi
		;;
	Mac)
		if command -v brew &>/dev/null; then
			PACKAGE_MANAGER="brew"
		else
			log_warn "Homebrew not found. Consider installing it."
		fi
		;;
	Windows)
		if command -v scoop &>/dev/null; then
			PACKAGE_MANAGER="scoop"
		else
			log_warn "Scoop not found. Consider installing it."
		fi
		;;
	esac

	export PACKAGE_MANAGER
}

# Install dependencies
install_dependencies() {
	log_step "Checking dependencies..."

	local deps=("git" "curl")
	local missing_deps=()

	for dep in "${deps[@]}"; do
		if ! command -v "$dep" &>/dev/null; then
			missing_deps+=("$dep")
		fi
	done

	if [[ ${#missing_deps[@]} -eq 0 ]]; then
		log_success "All dependencies are installed"
		return 0
	fi

	log_warn "Missing dependencies: ${missing_deps[*]}"

	if [[ -n "${PACKAGE_MANAGER:-}" ]]; then
		read -rp "Install missing dependencies with $PACKAGE_MANAGER? [y/N]: " response
		if [[ "$response" =~ ^[Yy]$ ]]; then
			for dep in "${missing_deps[@]}"; do
				case "$PACKAGE_MANAGER" in
				apt) sudo apt-get install -y "$dep" ;;
				dnf) sudo dnf install -y "$dep" ;;
				pacman) sudo pacman -S --noconfirm "$dep" ;;
				zypper) sudo zypper install -y "$dep" ;;
				brew) brew install "$dep" ;;
				scoop) scoop install "$dep" ;;
				winget) winget install "$dep" ;;
				esac
			done
		fi
	fi
}

# Validate prerequisites
validate_prerequisites() {
	log_step "Validating prerequisites..."

	# Check if we're in the dotfiles directory
	if [[ ! -d "${DOTFILES_DIR}/home" ]] || [[ ! -d "${DOTFILES_DIR}/config" ]]; then
		log_error "Invalid dotfiles structure. Missing home/ or config/ directories."
		log_error "Make sure you're running this script from the dotfiles directory."
		return 1
	fi

	# Check if template exists
	if [[ ! -f "$CONFIG_TEMPLATE" ]]; then
		log_error "Configuration template not found: $CONFIG_TEMPLATE"
		return 1
	fi

	# Check write permissions
	if [[ ! -w "$HOME" ]]; then
		log_error "No write permission to home directory: $HOME"
		return 1
	fi

	log_success "Prerequisites validated"
	return 0
}
# Setup Git configuration
setup_git_config() {
	log_step "Setting up Git configuration..."
	##TODO: Implement Git configuration setup
}

# Install bin scripts
install_bin_scripts() {
	log_step "Installing bin scripts..."
	##TODO: Implement bin scripts installation
}

# Health check
health_check() {
	log_step "Running health check..."
	##TODO: Implement health check
}

# Post-installation tasks
post_install() {
	log_step "Running post-install tasks..."

	setup_git_config
	install_bin_scripts

	log_success "Installation complete!"
	log_info "Backup stored in: $BACKUP_DIR"
	echo
	log_info "Next steps:"
	log_info "1. Restart your terminal or run: source ~/.bashrc"
	log_info "2. Type 'f1' for help and available commands"
	log_info "3. Customize config/bash/local.bash for machine-specific settings"

	if [[ $ERRORS_OCCURRED -gt 0 ]]; then
		log_warn "Installation completed with errors. Check the output above."
	fi
}

# Main function
main() {
	cat <<EOF
╔═══════════════════════════════════════╗
║        DOTFILES INSTALLER v2.0        ║
╚═══════════════════════════════════════╝
EOF

	detect_os
	log_info "Detected OS: $OS"

	# Validate prerequisites
	if ! validate_prerequisites; then
		log_error "Prerequisites check failed"
		read -p "Press Enter to exit..."
		return 1
	fi

	if ! load_config; then
		if ! setup_configuration; then
			log_error "Configuration setup failed"
			return 1
		fi
		# Reload after creation
		load_config || {
			log_error "Failed to load generated configuration"
			return 1
		}
	fi

	#Running instalation steps
	log_info "Starting installation with configuration: $CONFIG_FILE"
	setup_package_manager
	install_dependencies
	install_home_dotfiles
	install_config_dotfiles
	install_work_structure
	link_editorconfig
	post_install

	if [[ $ERRORS_OCCURRED -gt 0 ]]; then
		log_warn "Installation completed with errors. Check the output above."
	else
		log_info "Done! Backup stored in: $BACKUP_DIR"
	fi

	echo
	read -p "Press Enter to exit..."
}

# Ejecutar si no es sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	main "$@"
	exit $ERRORS_OCCURRED
else
	log_warn "This script is intended to be run, not sourced. Please check if the files has the execute permissions (chmod +x install.sh)."
	return 1
fi
