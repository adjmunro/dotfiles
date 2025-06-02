#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   rust/env   
# --------------------------------------------------------------------------- #
whence cargo &>/dev/null || return false 
echo "Source $0"

# Source Cargo Environment
source "$HOME/.cargo/env"
