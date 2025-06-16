#!/usr/bin/env bash
# Help system for dotfiles

echo "Loading help system..."

# Main help function
f1() {
	local topic="${1:-}"

	case "$topic" in
	-a | --aliases | aliases)
		show_aliases
		;;
	-f | --functions | functions)
		show_functions
		;;
	-v | --variables | variables)
		show_variables
		;;
	-g | --git | git)
		show_git_help
		;;
	-s | --shortcuts | shortcuts)
		show_shortcuts
		;;
	-c | --commands | commands)
		show_commands
		;;
	"")
		show_main_help
		;;
	*)
		echo "Unknown help topic: $topic"
		echo "Try 'f1' without arguments for main help"
		return 1
		;;
	esac
}

# Show main help menu
show_main_help() {
	cat <<'EOF'
╔════════════════════════════════════════════╗
║          DOTFILES HELP SYSTEM              ║
╚════════════════════════════════════════════╝

Quick Start:
  f1              Show this help
  f1 -a           Show aliases
  f1 -f           Show functions
  f1 -v           Show variables
  f1 -g           Show git help
  f1 -s           Show keyboard shortcuts
  f1 -c           Show custom commands

Navigation:
  home            Go to personal home directory
  work            Go to work directory
  dots            Go to dotfiles config
  wp              Go to work projects
  pp              Go to personal projects

Common Tasks:
  reload          Reload shell configuration
  update          Update system packages
  gac "msg"       Git add all & commit
  mkcd dirname    Create and enter directory
  extract file    Extract archive

For detailed help on any topic, use: f1 <topic>
EOF
}

# Show aliases
show_aliases() {
	echo "═══════════════════════════════════════════"
	echo "                 ALIASES"
	echo "═══════════════════════════════════════════"
	echo
	echo "Navigation:"
	echo "  ..              = cd .."
	echo "  ...             = cd ../.."
	echo "  home            = cd to personal home"
	echo "  work            = cd to work directory"
	echo "  config          = cd to ~/.config"
	echo
	echo "Listing:"
	echo "  ll              = detailed list"
	echo "  la              = list all"
	echo "  lt              = tree view"
	echo
	echo "Git shortcuts:"
	echo "  g               = git"
	echo "  gs              = git status"
	echo "  ga              = git add"
	echo "  gc              = git commit"
	echo "  gp              = git push"
	echo "  gpl             = git pull"
	echo "  gco             = git checkout"
	echo "  gcb             = git checkout -b"
	echo
	echo "Utilities:"
	echo "  cls             = clear screen"
	echo "  reload          = reload shell"
	echo "  myip            = show public IP"
	echo "  weather [city]  = show weather"
	echo
	echo "Type 'alias' to see all defined aliases"
}

# Show functions
show_functions() {
	echo "═══════════════════════════════════════════"
	echo "                FUNCTIONS"
	echo "═══════════════════════════════════════════"
	echo
	echo "Directory Operations:"
	echo "  mkcd <dir>      Create directory and cd into it"
	echo "  tmpd [name]     Create temp directory and cd into it"
	echo "  ff <pattern>    Find files by name"
	echo "  fd <pattern>    Find directories by name"
	echo
	echo "File Operations:"
	echo "  extract <file>  Extract any archive format"
	echo "  backup <file>   Create timestamped backup"
	echo "  sizeof [files]  Show file sizes"
	echo
	echo "Git Functions:"
	echo "  gac <msg>       Add all and commit"
	echo "  gacp <msg>      Add all, commit, and push"
	echo "  gpp             Push to current branch"
	echo "  gpull           Pull from current branch"
	echo "  glog            Pretty git log"
	echo "  gclean          Remove merged branches"
	echo
	echo "System Functions:"
	echo "  topcpu [n]      Show top N CPU processes"
	echo "  topmem [n]      Show top N memory processes"
	echo "  serve [port]    Start HTTP server"
	echo "  genpass [len]   Generate password"
	echo
	echo "Development:"
	echo "  todos           Find all TODO/FIXME comments"
	echo "  dataurl <file>  Create data URL from file"
	echo
	if command -v docker &>/dev/null; then
		echo "Docker Functions:"
		echo "  dockerclean     Remove all containers/images"
		echo "  dockerip <cnt>  Show container IP"
	fi
}

# Show variables
show_variables() {
	echo "═══════════════════════════════════════════"
	echo "              VARIABLES"
	echo "═══════════════════════════════════════════"
	echo
	echo "Personal Directories:"
	local vars=(
		"MY_FOLDER:Personal organization directory"
		"MY_WORK_FOLDER_PATH:Work directory"
		"MY_PERSONAL_FOLDER_PATH:Personal projects"
		"MY_KEYS_FOLDER:Keys/credentials directory"
	)

	for var in "${vars[@]}"; do
		IFS=':' read -r name desc <<<"$var"
		if [[ -n "${!name}" ]]; then
			printf "  %-20s = %s\n" "$name" "${!name}"
			printf "  %-20s   %s\n" "" "$desc"
			echo
		fi
	done

	echo "Configuration:"
	echo "  EDITOR          = ${EDITOR:-not set}"
	echo "  VISUAL          = ${VISUAL:-not set}"
	echo "  DOTFILES_THEME  = ${DOTFILES_THEME:-default}"
	echo
	echo "System:"
	echo "  OS_TYPE         = ${OS_TYPE:-unknown}"
	echo "  SHELL           = $SHELL"
	echo "  BASH_VERSION    = $BASH_VERSION"
}

# Show git help
show_git_help() {
	echo "═══════════════════════════════════════════"
	echo "                GIT HELP"
	echo "═══════════════════════════════════════════"
	echo
	echo "Basic Workflow:"
	echo "  gs              Check status"
	echo "  ga .            Add all changes"
	echo "  gc -m 'msg'     Commit with message"
	echo "  gp              Push to remote"
	echo "  gpl             Pull from remote"
	echo
	echo "Branching:"
	echo "  gb              List branches"
	echo "  gco <branch>    Switch branch"
	echo "  gcb <branch>    Create and switch branch"
	echo "  gm <branch>     Merge branch"
	echo
	echo "History:"
	echo "  gl              One-line log"
	echo "  glog            Pretty log with graph"
	echo "  gd              Show diff"
	echo "  gds             Show staged diff"
	echo
	echo "Advanced:"
	echo "  gf              Fetch all remotes"
	echo "  grb             Interactive rebase"
	echo "  gss             Stash changes"
	echo "  gsp             Pop stash"
	echo "  gclean          Remove merged branches"
	echo
	echo "Aliases:"
	echo "  Type 'git aliases' to see all git aliases"
}

# Show keyboard shortcuts
show_shortcuts() {
	echo "═══════════════════════════════════════════"
	echo "            KEYBOARD SHORTCUTS"
	echo "═══════════════════════════════════════════"
	echo
	echo "Bash Navigation:"
	echo "  Ctrl+A          Move to line start"
	echo "  Ctrl+E          Move to line end"
	echo "  Alt+B           Move back one word"
	echo "  Alt+F           Move forward one word"
	echo
	echo "Bash Editing:"
	echo "  Ctrl+U          Cut to line start"
	echo "  Ctrl+K          Cut to line end"
	echo "  Ctrl+W          Cut previous word"
	echo "  Ctrl+Y          Paste (yank)"
	echo "  Alt+D           Delete next word"
	echo
	echo "History:"
	echo "  Ctrl+R          Search history"
	echo "  Ctrl+G          Cancel search"
	echo "  !!              Repeat last command"
	echo "  !$              Last argument of previous command"
	echo
	echo "Terminal Control:"
	echo "  Ctrl+L          Clear screen"
	echo "  Ctrl+C          Cancel current command"
	echo "  Ctrl+D          Exit/EOF"
	echo "  Ctrl+Z          Suspend process"
}

# Show custom commands
show_commands() {
	echo "═══════════════════════════════════════════"
	echo "            CUSTOM COMMANDS"
	echo "═══════════════════════════════════════════"
	echo
	echo "Dotfiles Management:"
	echo "  dotfiles-update Check and update dotfiles"
	echo
	echo "Package Management:"
	echo "  update          Update system packages"
	echo
	echo "Network:"
	echo "  myip            Show public IP"
	echo "  localip         Show local IP"
	echo "  serve [port]    Start HTTP server"
	echo
	echo "System Info:"
	echo "  path            Show PATH entries"
	echo "  now             Current date/time"
	echo "  week            Current week number"
	echo
	echo "Development:"
	echo "  c.              Open VSCode in current dir"
	echo "  activate        Activate Python venv"
	echo
	echo "Type 'type <command>' to see command definition"
}

# Add help for f1 itself
help() {
	f1 "$@"
}

# Export the help function
export -f f1 help

echo "Help system loaded. Use 'f1' for main help menu."
