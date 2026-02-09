#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   mise/alias 
# --------------------------------------------------------------------------- #

# Check that mise is installed
which mise &>/dev/null || return false

# Easy config
a cmise="edit ~/.config/mise/config.toml"

# Fix mise cache
a fix-mise="mise cache clear; mise cache prune"
