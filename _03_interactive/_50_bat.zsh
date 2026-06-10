#!/usr/bin/env zsh

# Check that bat is installed
installed bat || return $SKIP_DOTFILE

# Override the default "file viewer"
export VIEW="bat"
