#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Check that mise is installed
installed mise || return $SKIP_DOTFILE

# --------------------------------------------------------------------------- #

info "=== Update Mise Version Manager ===\n"

# Clean mise cache (precaution)
fix-mise

# Upgrade versions
mise upgrade

# Prune old versions (yes to all prompts)
mise prune --yes

# List managed installs & versions
mise list
