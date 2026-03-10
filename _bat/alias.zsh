#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   bat/alias   
# --------------------------------------------------------------------------- #

# Check that bat is installed
whence bat &>/dev/null || return false 

# Override the default "file viewer"
export VIEW="bat"
