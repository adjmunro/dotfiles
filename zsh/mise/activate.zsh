#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   mise/activate   
# --------------------------------------------------------------------------- #

# Check that mise is installed.
whence mise &>/dev/null || return false
printf "Activate %-15s %s\n" "Mise" "@$(whence -p mise)"

# Activate mise.
eval "$(mise activate zsh)"

