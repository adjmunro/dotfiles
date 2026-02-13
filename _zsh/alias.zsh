#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zsh/alias
# --------------------------------------------------------------------------- #

# List Aliases, Functions, Parameters
a aliases="print -rl -- ${(k)aliases}"

# Re-source zsh config files (only if present)
function restart() {
    # Set flag to skip abbreviation re-adding during restart
    export _RESTART_IN_PROGRESS=1

    [[ -f ~/.zshenv ]] && source ~/.zshenv
    [[ -f ~/.zprofile ]] && source ~/.zprofile
    [[ -f ~/.zshrc ]] && source ~/.zshrc
    [[ -f ~/.zlogin ]] && source ~/.zlogin

    # Clear the flag
    unset _RESTART_IN_PROGRESS
}

# Redo previous command with sudo
a pls="sudo !!"

# Navigate up directories
a ..="cd .."
a ...="cd ../.."

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

# Clear all aliases from config.
function unalias-all() {
    unalias -m '*'
}
