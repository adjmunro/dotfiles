#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   eza/alias   
#               ls and tree replacements
# --------------------------------------------------------------------------- #

# Check that eza is installed
whence eza &>/dev/null || return false
echo "Source $0"

# Pretty-print ls
alias 1="eza --all --git-ignore --long --header --no-permissions --no-user --time-style=relative --group-directories-first --icons=always --classify=always"

# Pretty-print tree
alias 2="1 --tree --level 1"
alias 3="1 --tree --level 2"
alias 4="1 --tree --level 3"
alias 5="1 --tree --level 4"
alias 6="1 --tree --level 5"
alias 7="1 --tree --level 6"
alias 8="1 --tree --level 7"
alias 9="1 --tree --level 8"

