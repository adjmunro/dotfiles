#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Check that homebrew is installed (again)
[[ -x $BREW/brew ]] || return $SKIP_DOTFILE

# --------------------------------------------------------------------------- #

# Load Homebrew after macOS path_helper (after zshenv)
# so /opt/homebrew/bin stays ahead of system
# paths like /usr/bin in login shells.
eval "$($BREW/brew shellenv)"
