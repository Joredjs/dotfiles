#!/usr/bin/env bash
# colors.bash - Color definitions and theme support - OPTIMIZED

[[ "${DOTFILES_SILENT:-}" != "1" ]] && echo "$(date +%T): Loading colors configuration ..."

# Verificar soporte de colores una sola vez
_colors_supported=false
if tput setaf 1 &>/dev/null; then
    _colors_supported=true
fi

# Función para definir colores según capacidad del terminal
setup_colors() {
    if [[ "$_colors_supported" == true ]]; then
        # Terminal con soporte completo de tput
        BLACK=$(tput setaf 0)
        RED=$(tput setaf 1)
        GREEN=$(tput setaf 2)
        YELLOW=$(tput setaf 3)
        BLUE=$(tput setaf 4)
        PURPLE=$(tput setaf 5)
        CYAN=$(tput setaf 6)
        WHITE=$(tput setaf 7)
        ORANGE=$(tput setaf 208 2>/dev/null || tput setaf 3)
        MAGENTA=$(tput setaf 141 2>/dev/null || tput setaf 5)
        BOLD=$(tput bold)
        DIM=$(tput dim)
        UNDERLINE=$(tput smul)
        RESET=$(tput sgr0)

        # Background colors
        BG_BLACK=$(tput setab 0)
        BG_RED=$(tput setab 1)
        BG_GREEN=$(tput setab 2)
        BG_YELLOW=$(tput setab 3)
        BG_BLUE=$(tput setab 4)
        BG_PURPLE=$(tput setab 5)
        BG_CYAN=$(tput setab 6)
        BG_WHITE=$(tput setab 7)

				export BLACK RED GREEN YELLOW BLUE PURPLE CYAN WHITE ORANGE MAGENTA BOLD DIM UNDERLINE RESET
				export BG_BLACK BG_RED BG_GREEN BG_YELLOW BG_BLUE BG_PURPLE BG_CYAN BG_WHITE
    else
        # Fallback ANSI colors
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
    fi
}

# Theme configuration
setup_theme_colors() {
    # Git status colors (universales)
    export GIT_STAGED_COLOR="$GREEN"
    export GIT_MODIFIED_COLOR="$ORANGE"
    export GIT_DELETED_COLOR="$RED"
    export GIT_UNTRACKED_COLOR="$YELLOW"
    export GIT_CLEAN_COLOR="$CYAN"

    # Theme-specific prompt colors
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
}

# Ejecutar configuración
setup_colors
setup_theme_colors

# Cleanup
unset -f setup_colors setup_theme_colors
unset _colors_supported

[[ "${DOTFILES_SILENT:-}" != "1" ]] && echo "$(date +%T): Colors loaded successfully."
