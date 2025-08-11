#!/usr/bin/env bash
# Bash prompt configuration - FIXED VERSION for Git Bash

[[ "${DOTFILES_SILENT:-}" != "1" ]] && echo "$(date +%T): Loading prompt configuration ..."

# Variables globales para cache simple
_git_prompt_cache=""
_git_prompt_cache_pwd=""
_git_prompt_cache_time=0
_git_cache_timeout=5

# Función de Git prompt con cache simple (compatible con Bash 3.x+)
git_prompt() {
    local current_pwd="$(pwd)"
    local current_time=$(date +%s 2>/dev/null || echo "0")

    # Verificar cache simple
    if [[ "$_git_prompt_cache_pwd" == "$current_pwd" ]] &&
       [[ -n "$_git_prompt_cache" ]] &&
       [[ $((current_time - _git_prompt_cache_time)) -lt $_git_cache_timeout ]]; then
        echo -e "$_git_prompt_cache"
        return
    fi

    # Verificar si estamos en un repo Git (rápido)
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        _git_prompt_cache=""
        _git_prompt_cache_pwd="$current_pwd"
        _git_prompt_cache_time="$current_time"
        return
    fi

    # Obtener nombre de branch (optimizado)
    local branchName=""
    branchName=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) || \
    branchName=$(git rev-parse --short HEAD 2>/dev/null) || \
    branchName="(detached)"

    # Stats de git (versión simplificada)
    local stats_result=""
    stats_result=$(git_stats_simple)

    local result="git=>${1}(${branchName})${2}${stats_result} "

    # Guardar en cache
    _git_prompt_cache="$result"
    _git_prompt_cache_pwd="$current_pwd"
    _git_prompt_cache_time="$current_time"

    echo -e "$result"
}

# Función simplificada de git stats (más compatible)
git_stats_simple() {
    # Una sola llamada a git status con formato porcelain
    local status_output=""
    status_output=$(git status --porcelain 2>/dev/null)

    # Si no hay cambios, retornar vacío
    if [[ -z "$status_output" ]]; then
        return 0
    fi

    # Contadores simples
    local stat_a=0 stat_m=0 stat_d=0

    # Procesar línea por línea usando while read (más compatible)
    while IFS= read -r line; do
        if [[ -n "$line" ]]; then
            local status_code="${line:0:2}"
            case "$status_code" in
                "A "|"??") stat_a=$((stat_a + 1)) ;;
                "M "|"R "|"C "|"UU"|" M") stat_m=$((stat_m + 1)) ;;
                "D "|" D") stat_d=$((stat_d + 1)) ;;
            esac
        fi
    done <<< "$status_output"

    # Construir string de stats
    local stats=""
    if [[ $stat_a -gt 0 ]]; then
        stats+="${GIT_STAGED_COLOR:-\033[0;32m}${stat_a}-"
    fi
    if [[ $stat_d -gt 0 ]]; then
        stats+="${GIT_DELETED_COLOR:-\033[0;31m}${stat_d}-"
    fi
    if [[ $stat_m -gt 0 ]]; then
        stats+="${GIT_MODIFIED_COLOR:-\033[0;33m}${stat_m}"
    fi

    if [[ -n "$stats" ]]; then
        echo "[$stats${RESET}]"
    fi
}

# Funciones auxiliares simples
__virtualenv_prompt() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo " ($(basename "$VIRTUAL_ENV"))"
    fi
}

__ssh_prompt() {
    if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
        echo "⚡"
    fi
}

# Setup del prompt principal
setup_prompt() {
    local prompt_symbol="$"

    # Color para root
    if [[ "${USER}" == "root" ]]; then
        PS1_USER_COLOR="${RED:-\033[0;31m}"
        prompt_symbol="#"
    fi

    # Color para SSH
    if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
        PS1_HOST_COLOR="${RED:-\033[0;31m}"
    fi

    # Usar colores por defecto si no están definidos
    PS1_USER_COLOR="${PS1_USER_COLOR:-\033[0;32m}"
    PS1_HOST_COLOR="${PS1_HOST_COLOR:-\033[0;34m}"
    PS1_PATH_COLOR="${PS1_PATH_COLOR:-\033[0;36m}"
    PS1_GIT_COLOR="${PS1_GIT_COLOR:-\033[0;35m}"
    PS1_TIME_COLOR="${PS1_TIME_COLOR:-\033[0;33m}"
    PS1_PROMPT_COLOR="${PS1_PROMPT_COLOR:-\033[0;37m}"
    WHITE="${WHITE:-\033[0;37m}"
    BOLD="${BOLD:-\033[1m}"
    RESET="${RESET:-\033[0m}"

    # Construir prompt
    PS1="\[\033]0;\W\007\]"                                    # Terminal title
    PS1+="\n"                                                  # New line
    PS1+="\[${PS1_USER_COLOR}\]\u\[${RESET}\]"                 # Username
    PS1+="\[${WHITE}\]@\[${RESET}\]"                           # @
    PS1+="\[${PS1_HOST_COLOR}\]\h\[${RESET}\]"                 # Hostname
    PS1+="\[${WHITE}\]:\[${RESET}\]"                           # :
    PS1+="\[${BOLD}${PS1_PATH_COLOR}\]\w \[${RESET}\]"         # Working directory
		PS1+='`git_prompt "\$PS1_GIT_COLOR" "\$RESET"`'           # Git info (cached)
    PS1+="\[${PS1_TIME_COLOR}\]\A\[${RESET}\]"                 # Time
    PS1+="\n"                                                  # New line
    PS1+="\${PS1_PROMPT_COLOR}\]${prompt_symbol}\[${RESET} "

    # Continuation prompt
    PS2="${YELLOW:-\033[0;33m}→ \[${RESET}\]"

    # Debug prompt
    PS4='+ ${BASH_SOURCE:-}:${LINENO:-}: ${FUNCNAME[0]:-}(): '
}

# Prompt alternativo minimal
minimal_prompt() {
    PS1="\W \$ "
    PS2="> "
}

# Limpiar cache cada cierto tiempo (función compatible)
_cleanup_git_cache() {
    local current_time=$(date +%s 2>/dev/null || echo "0")
    if [[ $((current_time - _git_prompt_cache_time)) -gt $((git_cache_timeout * 3)) ]]; then
        _git_prompt_cache=""
        _git_prompt_cache_pwd=""
        _git_prompt_cache_time=0
    fi
}

# Configurar según preferencia
case "${PROMPT_STYLE:-default}" in
    minimal)
        minimal_prompt
        ;;
    *)
        setup_prompt
        ;;
esac

# Agregar limpieza de cache al PROMPT_COMMAND si no existe
if [[ "$PROMPT_COMMAND" != *"_cleanup_git_cache"* ]]; then
    PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }_cleanup_git_cache"
fi

# Exportar prompts
export PS1 PS2 PS4

# Configuración de colores para ls y grep
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

[[ "${DOTFILES_SILENT:-}" != "1" ]] && echo "$(date +%T): Prompt configuration loaded successfully."
