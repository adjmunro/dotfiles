#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Check that thefuck is installed.
installed thefuck || return $SKIP_DOTFILE

# --------------------------------------------------------------------------- #

# Activate thefuck.
eval "$(thefuck --alias)"

debug "Activate %-15s %s\n" "TheFuck" "@$(whence -p thefuck)"
