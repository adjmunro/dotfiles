#!/usr/bin/env zsh

# ----------------------------- Guard ----------------------------- #

# Check that mise is installed
installed mise || return $SKIP_DOTFILE

# ---------------------------- Aliases ---------------------------- #

# Easy config
a .mise="edit ~/.config/mise/config.toml"

# Fix mise cache
a fix-mise="mise cache clear; mise cache prune"

# --------------------------- Activation -------------------------- #

# Activate mise.
debug "Activate %-15s %s\n" "Mise" "@$(whence -p mise)"
eval "$(mise activate zsh)"
