#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   eza/alias   
#               ls and tree replacements
# --------------------------------------------------------------------------- #

# Check that eza is installed
whence eza &>/dev/null || return false

# Pretty-print ls
alias 1="eza --all --git-ignore --long --header --no-permissions --no-user --time-style=relative --group-directories-first --icons=always --classify=always"
alias ll="1"

# Pretty-print tree
alias 2="1 --tree --level 2"
alias 3="1 --tree --level 3"
alias 4="1 --tree --level 4"
alias 5="1 --tree --level 5"
alias 6="1 --tree --level 6"
alias 7="1 --tree --level 7"
alias 8="1 --tree --level 8"
alias 9="1 --tree --level 9"
