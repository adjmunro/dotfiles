#!/usr/bin/env zsh

# Check that cargo is installed
installed cargo || return $SKIP_DOTFILE

# Source Cargo Environment
source "$HOME/.cargo/env"
