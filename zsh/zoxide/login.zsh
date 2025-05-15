#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zoxide/login   
# --------------------------------------------------------------------------- #

# Check that Zoxide is installed.
require zoxide && debug "Activate Zoxide > $(command -v zoxide)"

# Initialise Zoxide for Zsh
eval "$(zoxide init zsh)"

