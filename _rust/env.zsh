#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   rust/env   
# --------------------------------------------------------------------------- #
whence cargo &>/dev/null || return false 

# Source Cargo Environment
source "$HOME/.cargo/env"
