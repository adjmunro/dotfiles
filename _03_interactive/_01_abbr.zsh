#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Check that zsh-abbr is installed
installed abbr || return $SKIP_DOTFILE

# --------------------------------------------------------------------------- #

# Export abbr for humans only.
human && export ALIAS="abbr $@"
