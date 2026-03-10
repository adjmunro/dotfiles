#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zsh/alias
# --------------------------------------------------------------------------- #

# List Aliases, Functions, Parameters
a aliases="print -rl -- ${(k)aliases}"

# Re-source zsh config files (only if present)
function restart() {
    # Clear session abbreviations but keep persisted ones
    # This allows fresh reload without job queue timeout issues
    whence abbr &>/dev/null && ABBR_QUIET=1 abbr clear-session 2>/dev/null

    # Only source .zshrc which is usually sufficient for most changes
    # Sourcing all files can be slow and is rarely necessary
    if [[ -f ~/.zshrc ]]; then
        source ~/.zshrc
    else
        # Fallback to sourcing all if .zshrc doesn't exist
        [[ -f ~/.zshenv ]] && source ~/.zshenv
        [[ -f ~/.zprofile ]] && source ~/.zprofile
        [[ -f ~/.zlogin ]] && source ~/.zlogin
    fi
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
