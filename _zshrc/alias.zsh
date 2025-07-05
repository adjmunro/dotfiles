#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zshrc/alias   
# --------------------------------------------------------------------------- #

# Redo previous command with sudo
abbr pls="sudo !!"

# Navigate up one directory
abbr ..="cd .."

# Navigate up two directories
abbr ...="cd ../.."

# Navigate to last visited directory
abbr --="cd -"

# Make a new directory, and enter it.
abbr mkcd="mkdir -p $1 && cd $1"
