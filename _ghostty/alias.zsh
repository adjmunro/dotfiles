#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   ghostty/alias
# --------------------------------------------------------------------------- #

# Check that ghostty is installed
whence ghostty &>/dev/null || return false 

# Edit Ghostty local config
a .ghosttylocal="$EDITOR $DOTFILES/dot-config/ghostty/local-config"
a .ghostty="$EDITOR $DOTFILES/dot-config/ghostty/config"
