#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zsh/dotfiles   
# --------------------------------------------------------------------------- #

function dotfiles() {
    if (( $# == 0 )); then
        edit "$DOTFILES";
        return 0;
    fi;

    local sub=$1

    if [[ $sub = "sync" ]]; then
        git --git-dir="$DOTFILES" fetch origin main:main
    fi;
}

# ------------------------------
#   Zsh Configuration Files
# ------------------------------

# Note: there are also dotless, system-wide variants in /etc.
# These system-wide variants are always run *before* their user-specific
# counterparts (except /etc/zlogout, which is *after* ~/.zlogout).

# (1) Zsh Environment
# Always source for every invocation (login, interactive, & script)
# Used for user-specific environment variables
# !! Should be kept lean & fast!
alias zenv="edit ~/.zshenv"

# (-) Custom machine args (sourced by .zshenv)
alias zlocal="edit ~/.zlocal"

# (2) Zsh Profile
# Sourced for login shells after zshenv
# Used for user-specific login shell configurations
alias zprofile="edit ~/.zprofile"

# (3) Zsh Resource Config
# Sourced for interactive shells after zprofile
# Used for user-specific interactive shell configurations
alias zshrc="edit ~/.zshrc"

# (4) Zsh Login
# Sourced for login shells after all others
# Used for user-specific login commands
alias zlogin="edit ~/.zlogin"

# (5) Zsh Logout
# Sourced for login shells after the shell exists
# Used for cleanup tasks
# Sourced before /etc/zlogout
alias zlogout="edit ~/.zlogout"

# ------------------------------
#   Management
# ------------------------------

#alias reshell= /restart -- wait, i think i misunderstood login vs interactive but it work anyway atm because restart sources everything?

