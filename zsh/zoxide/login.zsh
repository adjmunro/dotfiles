#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zoxide/login   
# --------------------------------------------------------------------------- #

# Check that Zoxide is installed.
require zoxide && debugf "Activate %-15s %s\n" "Zoxide" "@$(command -v zoxide)"

# Initialise Zoxide for Zsh
eval "$(zoxide init zsh)"

