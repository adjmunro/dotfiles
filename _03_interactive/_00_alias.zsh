#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Zsh remembers which file each function came from (see $functions_source), but
# not aliases. Record "file:line" for every alias as it's defined so that
# `dotfiles --where <name>` can find it later.
typeset -gA DOTFILES_ALIAS_SOURCE

# Shadow the alias builtin to record each definition's call site, then defer to
# the real builtin. Listing (`alias` with no args) passes straight through.
function alias() {
    builtin alias "$@" || return

    # Walk past our own wrappers (e.g. `a`) to find the real caller. Sourced
    # files appear in $funcstack too, so the top-level caller is the file itself.
    local -i i=1
    while [[ ${funcstack[i+1]} == a ]]; do (( i++ )); done
    local src=${funcfiletrace[i]}

    # Record each name=value argument, skipping leading options (-g, -s, --).
    local arg
    local -i opts=1
    for arg in "$@"; do
        if (( opts )) && [[ $arg == -* ]]; then
            [[ $arg == -- ]] && opts=0
            continue
        fi
        opts=0
        [[ $arg == *=* ]] && DOTFILES_ALIAS_SOURCE[${arg%%=*}]=$src
    done
}

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
