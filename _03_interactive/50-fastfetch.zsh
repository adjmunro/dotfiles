#!/usr/bin/env zsh

# Check that fastfetch is installed
installed fastfetch || return $SKIP_DOTFILE

export SYS_INFO="fastfetch"
