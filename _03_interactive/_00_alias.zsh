#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# An overridable function for zsh aliases.
function a() { alias "$@" }

# An overridable function to dereference all defined aliases and functions.
function realias() {
    unalias -m '*' 2>/dev/null
    unfunction -m '*' 2>/dev/null

    [[ -f "~/.zshenv" ]] && source "~/.zshenv"
    [[ -f "~/.zprofile" ]] && source "~/.zprofile"
    [[ -f "~/.zshrc" ]] && source "~/.zshrc"
    [[ -f "~/.zlogin" ]] && source "~/.zlogin"
}
