#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   brew/update   
# --------------------------------------------------------------------------- #

debug "Update Homebrew Packages"

# Pull remote version database
brew update

# Update out-of-date packages
brew upgrade

# Remove old files & cache
brew cleanup

