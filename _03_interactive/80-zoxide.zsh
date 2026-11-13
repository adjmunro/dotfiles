#!/usr/bin/env zsh
autoload -U compinit && compinit

# --------------------------------------------------------------------------- #

# Check that Zoxide is installed.
installed zoxide || return $SKIP_DOTFILE

# --------------------------------------------------------------------------- #

# Initialise Zoxide for Zsh
eval "$(zoxide init zsh)"

debug "\nActivated %-15s %s\n" "Zoxide" "@$(whence -p zoxide)"
