#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   mise/login   
# --------------------------------------------------------------------------- #

# Check that mise is installed.
return $( require mis && debugf "Activate %-15s %s\n" "Mise" "@$(whence -p mise)"
)

echo "didn't escape!"
# Activate mise.
eval "$(mise activate zsh)"

