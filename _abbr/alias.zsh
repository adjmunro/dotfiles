#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zsh-abbr/alias   
# --------------------------------------------------------------------------- #

#this loops? alias aka="alias $1\=\"whence -v $1; $1\""

# Check that abbr is installed
whence abbr &>/dev/null || return false

abbr "e abbr"="e $ABBR_USER_ABBREVIATIONS_FILE"
abbr "rm abbr"="rm -rfd ${ABBR_USER_ABBREVIATIONS_FILE:h}"

# Override alias with abbr
abbr hw="echo \"Hello world~!\""
