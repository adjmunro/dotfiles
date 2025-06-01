#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zoxide/activate   
# --------------------------------------------------------------------------- #

# Check that Zoxide is installed.
whence zoxide &>/dev/null || return false
printf "Activate %-15s %s\n" "Zoxide" "@$(whence -p zoxide)"

# Initialise Zoxide for Zsh
eval "$(zoxide init zsh)"

