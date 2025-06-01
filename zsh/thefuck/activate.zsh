#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   thefuck/activate   
# --------------------------------------------------------------------------- #

# Check that thefuck is installed.
whence thefuck &>/dev/null || return false
printf "Activate %-15s %s\n" "TheFuck" "@$(whence -p thefuck)"

# Activate thefuck.
eval "$(thefuck --alias)"

