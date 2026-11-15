#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Check that homebrew is installed (again)
[[ -x $BREW/brew ]] || return $SKIP_DOTFILE

# --------------------------------------------------------------------------- #

# macOS /etc/zprofile runs path_helper between zshenv and zprofile, which moves
# system paths like /usr/bin ahead of Homebrew. _01_env already ran shellenv
# (HOMEBREW_* vars, fpath, INFOPATH), so only PATH order needs restoring here.
# Re-running shellenv would duplicate fpath and INFOPATH entries.
prepath "$BREW" "$HOMEBREW/sbin"
