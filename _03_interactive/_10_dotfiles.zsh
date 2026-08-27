#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Note: there are also dotless, system-wide variants in /etc.
# These system-wide variants are always run *before* their user-specific
# counterparts (except /etc/zlogout, which is *after* ~/.zlogout).

# (1) Zsh Environment
# Always source for every invocation (login, interactive, & script)
# Used for user-specific environment variables
# !! Should be kept lean & fast!
a zshenv="$EDITOR $DOTFILES/dot-zshenv"

# (-) Custom machine args (sourced by .zshenv)
a zlocal="$EDITOR $DOTFILES/_01_env/_50_local.zsh"

# (2) Zsh Profile
# Sourced for login shells after zshenv
# Used for user-specific login shell configurations
a zprofile="$EDITOR $DOTFILES/dot-zprofile"

# (3) Zsh Resource Config
# Sourced for interactive shells after zprofile
# Used for user-specific interactive shell configurations
a zshrc="$EDITOR $DOTFILES/dot-zshrc"

# (4) Zsh Login
# Sourced for login shells after all others
# Used for user-specific login commands
a zlogin="$EDITOR $DOTFILES/dot-zlogin"

# (5) Zsh Logout
# Sourced for login shells after the shell exists
# Used for cleanup tasks
# Sourced before /etc/zlogout
a zlogout="$EDITOR $DOTFILES/dot-zlogout"

# --------------------------------------------------------------------------- #

function dotfiles() {
    # No args => open file browser for dotfiles repo.
    if (( $# == 0 )); then
        $NAVIGATOR $DOTFILES;
        return true;
    fi;


    # If the first arg is "sync" fetch the git repo.
    local sub=$1
    if [[ $sub = "sync" ]]; then
        whence git &>/dev/null || return $(err "Git not installed!")
        git --git-dir="$DOTFILES" fetch origin main:main
    fi
}
