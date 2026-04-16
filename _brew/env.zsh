#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   brew/env   
# --------------------------------------------------------------------------- #

# Check that homebrew is installed
[[ -x /opt/homebrew/bin/brew ]] || return

# Load the homebrew shellenv for interactive
# and non-interactive shells.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Convenience shorthands
export BREW="/opt/homebrew/bin"
export HOMEBREW="/opt/homebrew"
