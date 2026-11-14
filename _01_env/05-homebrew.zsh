#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Check that homebrew is installed
[[ -x /opt/homebrew/bin/brew ]] || return $SKIP_DOTFILE

# --------------------------------------------------------------------------- #

# Convenience shorthand
export HOMEBREW="/opt/homebrew"
export HOMEBREW_OPT="$HOMEBREW/opt"
export BREW="$HOMEBREW/bin"

# Put Homebrew on PATH for non-login shells too (IDEs, GUI apps, agents),
# which never source zprofile. Login shells re-run this in _02_user after
# macOS path_helper reorders PATH.
eval "$($BREW/brew shellenv)"
