#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zsh/alias
# --------------------------------------------------------------------------- #

# List Aliases, Functions, Parameters
a aliases="print -rl -- ${(k)aliases}"

# Re-source zsh config files (only if present)
function restart() {
    # Only source .zshrc which is usually sufficient for most changes.
    # Use realias for a destructive alias/function rebuild.
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

# Make a new directory, and enter it.
function mkcd() {
    [[ -z "$1" ]] && return 1
    mkdir -p "$1" && cd "$1"
}

# Clear screen (reset cursor and scrollback area)
alias cls="printf \"\e[H\e[22J\""

# Info snapshot (only runs tools that exist)
function about() {
    clear # cls?
    $SYS_INFO
    whence ll &>/dev/null && ll
    whence branches &>/dev/null && branches
}
