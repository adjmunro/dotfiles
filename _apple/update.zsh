#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   apple/update   
# --------------------------------------------------------------------------- #

debug "Update Apple Software"

# Force check for all Apple updates, but download only.
softwareupdate --all --download --force --agree-to-license

