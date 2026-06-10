#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Check that Homebrew is installed
installed brew || return $SKIP_DOTFILE

# --------------------------------------------------------------------------- #

info "=== Update Homebrew Packages ===\n"

# Pull remote version database
brew update

# Update out-of-date packages
# Greedy is used to forcefully update self-updating casks
brew upgrade --greedy

# Remove old files & cache
brew cleanup

# Run brew doctor to check for issues
brew doctor
