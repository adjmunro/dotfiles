#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   thefuck/login   
# --------------------------------------------------------------------------- #

# Check that thefuck is installed.
require thefuck && debugf "Activate %-15s %s\n" "TheFuck" "@$(command -v thefuck)"

# Activate thefuck.
eval "$(thefuck --alias)"

