#!/usr/bin/env zsh

# `$DOTFILES/_machine.zsh` is a template for `$DOTFILES/_local.zsh`.
# Changes should be applied to both simultaneously! Real,
# machine-specific values must be removed from the `_machine.zsh` copy.
# Fresh installs should `cp -i $DOTFILES/_machine.zsh $DOTFILES/_local.zsh`.

# Set the machine name
export MACHINE=""

# Set the log severity filter to >= INFO severity
# i.e. warnings and errors too, but not verbose messages.
# One-time override via 'LOG_LEVEL=LOG_DEBUG zsh -ic <command>'
export LOG_LEVEL=${LOG_LEVEL:-LOG_INFO}
