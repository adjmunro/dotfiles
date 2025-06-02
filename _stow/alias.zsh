#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   stow/alias   
# --------------------------------------------------------------------------- #

# Check that GNU Stow is installed
whence stow &>/dev/null || return false

# Restow files all from DOTFILES to HOME, with dot-* substition.
alias restow="stow . --dir=$DOTFILES --target=$HOME --dotfiles --restow"


### TODO Rework these aliases in terms of core commands or move?

# Check that gfind is installed
whence gfind &>/dev/null || return false

# Prune empty directories
alias prune-dirs="gfind -type d -empty -delete"

# Clean up broken symlinks
alias prune-links="gfind -xtype l -delete"

