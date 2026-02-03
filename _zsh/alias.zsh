#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zsh/alias
# --------------------------------------------------------------------------- #

# List Aliases, Functions, Parameters
alias aliases="print -rl -- ${(k)aliases}"

# Re-source zsh config files (only if present)
function restart() {
    [[ -f ~/.zshenv ]] && source ~/.zshenv
    [[ -f ~/.zprofile ]] && source ~/.zprofile
    [[ -f ~/.zshrc ]] && source ~/.zshrc
    [[ -f ~/.zlogin ]] && source ~/.zlogin
}

# Redo previous command with sudo
alias pls="sudo !!"

# Navigate up directories
alias ..="cd .."
alias ...="cd ../.."

# Make a new directory, and enter it.
function mkcd() {
    [[ -z "$1" ]] && return 1
    mkdir -p "$1" && cd "$1"
}

# Clear screen (reset cursor and scrollback area)
alias cls="printf \"\e[H\e[22J\""

# Info snapshot (only runs tools that exist)
function info() {
    clear
    whence neofetch &>/dev/null && neofetch
    whence ll &>/dev/null && ll
    whence branches &>/dev/null && branches
}
