#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   brew/env   
# --------------------------------------------------------------------------- #

# Check that homebrew is installed
whence brew &>/dev/null || return false 

# ------------------------------
#   Export Install Path
# ------------------------------
export BREW="/opt/homebrew/bin"
export HOMEBREW="/opt/homebrew"
