#!/usr/bin/env bash
# Bash aliases configuration

[[ "${DOTFILES_SILENT:-}" != "1" ]] && echo "$(date +%T): Loading aliases configuration ..."

# Navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
# alias -- -='cd -'

# Personal navigation (using configured paths)
alias mydir='cd ${MY_FOLDER_PATH}'
alias work='cd ${MY_WORK_FOLDER_PATH}'
alias personal='cd ${MY_PERSONAL_FOLDER_PATH}'
alias config='cd ${XDG_CONFIG_HOME}'
alias dots='cd ${XDG_CONFIG_HOME'

# Project navigation
alias wp='cd ${MY_WORK_FOLDER_PATH}/${MY_PROJECTS_FOLDER}'
alias pp='cd ${MY_PERSONAL_FOLDER_PATH}/${MY_PROJECTS_FOLDER}'

# List aliases
if command -v eza &>/dev/null; then
	# Modern ls replacement
	alias ls='eza --icons'
	alias ll='eza -la --icons'
	alias la='eza -a --icons'
	alias lt='eza --tree --icons'
	alias llt='eza -la --tree --icons'
else
	# Fallback to standard ls
	alias ls='ls --color=auto'
	alias ll='ls -alF'
	alias la='ls -A'
	alias l='ls -CF'
fi

# Always use color output
# alias dir='dir --color=auto'
# alias vdir='vdir --color=auto'
# alias grep='grep --color=auto'
# alias fgrep='fgrep --color=auto'
# alias egrep='egrep --color=auto'

# Utility aliases
alias cls='clear'
alias f5='source ~/.bashrc'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%Y-%m-%d %H:%M:%S"'
alias week='date +%V'
alias myip='curl -s https://api.ipify.org && echo'
alias localip='hostname -I | cut -d" " -f1'

# Safety aliases
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias ln='ln -i'

# Make directories/parents
alias mkdir='mkdir -pv'

# Human readable sizes
alias df='df -h'
alias du='du -h'
alias free='free -h'

# Process management
alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias top='htop 2>/dev/null || top'

# Git aliases
if command -v git &>/dev/null; then
	alias g='git'
	alias gs='git status -sb'
	alias ga='git add'
	alias gaa='git add --all'
	alias gc='git commit -v'
	alias gcm='git commit -m'
	# alias gd='git diff'
	alias gds='git diff --staged'
	alias gpl='git pull origin "$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)"'
	alias gph='git push origin "$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)"'
	alias gpp='gpl && gph'
	alias gf='git fetch --all --prune'

	alias gb='git branch -vv'
	alias gba='git branch -vva'
	alias gbs='git branch -alv --sort=-committerdate --format="%(committerdate:short) %(objectname:short) %(refname:short) %(subject)"'

	alias gll='git log --oneline --graph --decorate'
	alias glla='git log --oneline --graph --decorate --all'

	alias gr='git remote -v'
	alias gst='git stash'
	alias gstp='git stash pop'
	alias gm='git merge'
	alias grb='git rebase'
	alias gcls='git clean -d -f'

	# Advanced git aliases
	# alias gwip='git add -A; git commit --no-verify -m "WIP"'
	# alias gunwip='git log -n 1 | grep -q -c "WIP" && git reset HEAD~1'
fi

# Docker aliases
if command -v docker &>/dev/null; then
	alias dk='docker'
	alias dkc='docker-compose'
	alias dkps='docker ps'
	alias dkpsa='docker ps -a'
	alias dki='docker images'
	alias dkex='docker exec -it'
	alias dklog='docker logs -f'
	alias dkstop='docker stop $(docker ps -q)'
	alias dkrm='docker rm $(docker ps -aq)'
	alias dkprune='docker system prune -af'
fi

# Editor aliases
alias e='${EDITOR:-vim}'
alias v='${VISUAL:-${EDITOR:-vim}}'
# if command -v code &>/dev/null; then
#     alias c='code'
#     alias cd.='code .'
# fi
if command -v nvim &>/dev/null; then
	alias vim='nvim'
	alias vi='nvim'
fi

# OS specific aliases
case "$OS" in
macos)
	alias showfiles='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
	alias hidefiles='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'
	alias update='brew update && brew upgrade && brew cleanup'
	alias o='open'
	alias o.='open .'
	;;
linux)
	alias update='sudo apt update && sudo apt upgrade'
	alias open='xdg-open'
	alias o='xdg-open'
	alias o.='xdg-open .'
	alias pbcopy='xclip -selection clipboard'
	alias pbpaste='xclip -selection clipboard -o'
	;;
windows)
	alias open='start'
	alias o='start'
	alias o.='start .'
	alias update='scoop upgrade && cd ${MY_PACKAGE_PATH}/apps && scoop cleanup *'
	;;
esac

# Python aliases

alias python='python3'
alias pip='pip3'
alias venv='python -m venv'
alias activate='source venv/bin/activate 2>/dev/null || source .venv/bin/activate'

# Node aliases

alias npmi='npm install'
alias npmid='npm install --save-dev'
alias npmig='npm install -g'
alias npmr='npm run'
alias npms='npm start'
alias npmt='npm test'
alias npmb='npm run build'

# Quick edit configs
alias bashrc='${EDITOR:-vim} ~/.bashrc'
alias aliases='${EDITOR:-vim} ${XDG_CONFIG_HOME:-$HOME/.config}/bash/aliases.bash'
alias gitconfig='${EDITOR:-vim} ~/.gitconfig'

[[ "${DOTFILES_SILENT:-}" != "1" ]] && echo "$(date +%T): Aliases configuration loaded successfully."
