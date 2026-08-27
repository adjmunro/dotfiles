#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Check that the Android CLI is installed.
installed "$HOME/.local/bin/android" || return $SKIP_DOTFILE

# --------------------------------------------------------------------------- #

info "=== Update Android CLI ===\n"

# Update the Android CLI (e.g. android skills)
android update
