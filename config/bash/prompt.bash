#!/usr/bin/env bash
# Bash prompt configuration

echo "Loading prompt configuration..."

# Git prompt support
git_prompt() {
	local branchName=""
	local s=""

	# Check if we're in a git repo
	git rev-parse --is-inside-work-tree &>/dev/null || return

	# Get branch name
	branchName="$(git symbolic-ref --quiet --short HEAD 2>/dev/null ||
		git describe --all --exact-match HEAD 2>/dev/null ||
		git rev-parse --short HEAD 2>/dev/null ||
		echo '(unknown)')"

	# Check for uncommitted changes
	if ! git diff --quiet --ignore-submodules --cached; then
		s+="+" # Staged changes
	fi

	if ! git diff-files --quiet --ignore-submodules --; then
		s+="!" # Unstaged changes
	fi

	if [ -n "$(git ls-files --others --exclude-standard)" ]; then
		s+="?" # Untracked files
	fi

	if git rev-parse --verify refs/stash &>/dev/null; then
		s+="$" # Stashed changes
	fi

	[ -n "${s}" ] && s=" [${s}]"

	echo -e " ${1}git(${branchName})${2} - staged:${s}"
}

# Displays the number of files pending commit
git_stats() {
	STATUS=$(git status -s 2>/dev/null)

	ADDED=$(echo "$STATUS" | grep -c 'A ')
	UNTRACKED=$(echo "$STATUS" | grep -c '??')
	MODIFIED=$(echo "$STATUS" | grep -c 'M ')
	RENAMED=$(echo "$STATUS" | grep -c 'R ')
	COPIED=$(echo "$STATUS" | grep -c 'C ')
	UNMERGED=$(echo "$STATUS" | grep -c 'U')
	DELETED=$(echo "$STATUS" | grep -c 'D ')

	stat_a=$((ADDED + UNTRACKED))
	stat_m=$((MODIFIED + RENAMED + COPIED + UNMERGED))
	stat_d=$((DELETED))

	STATS=""
	if [ $stat_a != 0 ]; then
		STATS+="${GIT_STAGED_COLOR} $stat_a "
	fi
	if [ $stat_d != 0 ]; then
		STATS+="${GIT_DELETED_COLOR} $stat_d "
	fi
	if [ $stat_m != 0 ]; then
		STATS+="${GIT_MODIFIED_COLOR} $stat_m "
	fi

	echo -e "stats:$STATS${RESET}"
}

# Get virtualenv info
__virtualenv_prompt() {
	if [[ -n "$VIRTUAL_ENV" ]]; then
		echo " ($(basename "$VIRTUAL_ENV"))"
	fi
}

# Get node version if in a node project
__node_prompt() {
	if [[ -f "package.json" ]] && command -v node &>/dev/null; then
		echo " [node $(node -v 2>/dev/null | sed 's/v//')]"
	fi
}

# Get kubernetes context if kubectl is available
__kube_prompt() {
	if command -v kubectl &>/dev/null && [[ -f "$HOME/.kube/config" ]]; then
		local context
		context=$(kubectl config current-context 2>/dev/null)
		if [[ -n "$context" ]]; then
			echo " [k8s:${context}]"
		fi
	fi
}

# Check if SSH connection
__ssh_prompt() {
	if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
		echo "⚡"
	fi
}

# Setup the main prompt
setup_prompt() {
	local prompt_symbol="$"

	# User color (red for root)
	if [[ "${USER}" == "root" ]]; then
		PS1_USER_COLOR="${RED}"
		prompt_symbol="#"
	fi

	# Host color (different for SSH)
	if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
		PS1_HOST_COLOR="${RED}"
	fi

	# Build the prompt
	PS1="\[\033]0;\W\007\]" # Terminal title

	# First line: user@host:path time
	PS1+="\n"                                                   # New line
	PS1+="\[${PS1_USER_COLOR}\]\u\[${RESET}\]"                  # Username
	PS1+="\[${WHITE}\]@\[${RESET}\]"                            # @
	PS1+="\[${PS1_HOST_COLOR}\]\h\[${RESET}\]"                  # Hostname
	PS1+="$(__ssh_prompt)"                                      # SSH indicator
	PS1+="\[${WHITE}\]:\[${RESET}\]"                            # :
	PS1+="\[${BOLD}${PS1_PATH_COLOR}\]\w\[${RESET}\]"           # Working directory
	PS1+='`git_prompt "\$PS1_GIT_COLOR" "\$RESET"` `git_stats`' # Git branch info and git stats
	PS1+='${YELLOW}`__virtualenv_prompt`${RESET}'               # Virtualenv info
	PS1+='${GREEN}`__node_prompt`${RESET}'                      # Node version info
	PS1+='${BLUE}`__kube_prompt`${RESET}'                       # Kubernetes context info
	PS1+="\$[${PS1_TIME_COLOR}\]\A\[${RESET}\]"                 # Time in HH:MM format

	# Second line: prompt symbol
	PS1+="\n"
	PS1+="\[${PS1_PROMPT_COLOR}\]${prompt_symbol}\[${RESET}\] "

	# Continuation prompt
	PS2="\[${YELLOW}\]→ \[${RESET}\]"

	# Debug prompt
	PS4='+ ${BASH_SOURCE:-}:${LINENO:-}: ${FUNCNAME[0]:-}(): '
}

# Alternative minimal prompt
minimal_prompt() {
	PS1="\W \$ "
	PS2="> "
}

# Alternative fancy prompt with powerline symbols
fancy_prompt() {
	# Requires powerline fonts
	local sep=""
	local subsep=""

	PS1="\n"
	PS1+="\[${BG_BLUE}${WHITE}\] \u \[${BLUE}${BG_CYAN}\]${sep}"
	PS1+="\[${BLACK}${BG_CYAN}\] \h \[${CYAN}${BG_PURPLE}\]${sep}"
	PS1+="\[${WHITE}${BG_PURPLE}\] \w \[${PURPLE}${RESET}\]${sep}"
	PS1+="\$(__git_prompt \" ${GREEN}\" \"${RESET}\")"
	PS1+="\n\[${ORANGE}\]❯\[${RESET}\] "
}

# Set prompt based on preference
case "${PROMPT_STYLE:-default}" in
minimal)
	minimal_prompt
	;;
fancy)
	if [[ "$TERM" == *"256color"* ]]; then
		fancy_prompt
	else
		setup_prompt
	fi
	;;
*)
	setup_prompt
	;;
esac

# Export prompts
export PS1 PS2 PS4

# Enable color in ls and grep
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
# export GREP_OPTIONS='--color=auto'

echo "Prompt configuration loaded successfully."
