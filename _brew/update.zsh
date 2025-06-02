#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   brew/update   
# --------------------------------------------------------------------------- #

# Check that Homebrew is installed
whence brew &>/dev/null || return false
echo "Update Homebrew Packages"

# Pull remote version database
brew update

# Update out-of-date packages
brew upgrade

# Remove old files & cache
brew cleanup

# Run brew doctor to check for issues
brew doctor

