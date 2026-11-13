#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Check that homebrew is installed
[[ -x /opt/homebrew/bin/brew ]] || return $SKIP_DOTFILE

# --------------------------------------------------------------------------- #

# Convenience shorthand
export HOMEBREW="/opt/homebrew"
export HOMEBREW_OPT="$HOMEBREW/opt"
export BREW="$HOMEBREW/bin"
