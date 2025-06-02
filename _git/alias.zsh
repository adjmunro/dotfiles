#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   git/alias   
# --------------------------------------------------------------------------- #

# Check that Git is installed
whence git &>/dev/null || return false

# Delete merbed branches? TODO(verify!)
alias gdmb='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'

