#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   aerospace/alias.zsh   
# --------------------------------------------------------------------------- #

# Check that aerospace is installed
whence aerospace &>/dev/null || return false 

a .aerospace="$EDITOR $DOTFILES/dot-config/aerospace/aerospace.toml"

