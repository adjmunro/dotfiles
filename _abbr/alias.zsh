#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zsh-abbr/alias   
# --------------------------------------------------------------------------- #

#this loops? alias aka="alias $1\=\"whence -v $1; $1\""

# Check that abbr is installed
whence abbr &>/dev/null || return false

a "e abbr"="e $ABBR_USER_ABBREVIATIONS_FILE"
a "rm abbr"="rm -rfd ${ABBR_USER_ABBREVIATIONS_FILE:h}"

# `--` is valid for abbr, but not for alias.
if [[ "${ABBR_VERBOSE:-0}" == "1" ]]; then
    abbr --force --="cd -"
else
    ABBR_QUIET=1 ABBR_QUIETER=1 abbr --force --="cd -"
fi
