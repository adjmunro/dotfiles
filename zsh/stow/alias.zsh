#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   stow/alias   
# --------------------------------------------------------------------------- #

# Restow files all from DOTFILES to HOME, with dot-* substition.
alias restow="stow . --dir=$DOTFILES --target=$HOME --dotfiles --restow"


### TODO Rework these aliases in terms of core commands or move?

# Prune empty directories
alias prune-dirs="gfind -type d -empty -delete"

# Clean up broken symlinks
alias prune-links="gfind -xtype l -delete"

