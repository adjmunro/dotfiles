#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   eza/alias   
#               ls and tree replacements
# --------------------------------------------------------------------------- #

# Check that eza is installed
whence eza &>/dev/null || return false

# Override default "list directory contents"
export LIST_DIRECTORY=(eza --all --long --header --no-permissions --no-user --time-style=relative --group-directories-first --icons=always --classify=always)

# Pretty-print tree
alias 1="$LIST_DIRECTORY"
alias 2="$LIST_DIRECTORY --tree --level 2"
alias 3="$LIST_DIRECTORY --tree --level 3"
alias 4="$LIST_DIRECTORY --tree --level 4"
alias 5="$LIST_DIRECTORY --tree --level 5"
alias 6="$LIST_DIRECTORY --tree --level 6"
alias 7="$LIST_DIRECTORY --tree --level 7"
alias 8="$LIST_DIRECTORY --tree --level 8"
alias 9="$LIST_DIRECTORY --tree --level 9"
alias 0="$LIST_DIRECTORY .."

