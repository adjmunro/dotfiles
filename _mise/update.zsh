#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   mise/update   
# --------------------------------------------------------------------------- #

# Check that mise is installed
which mise &>/dev/null || return false
echo "Update Mise Version Manager"

# Clean mise cache (precaution)
fix-mise

# Upgrade versions
mise upgrade

# Prune old versions (yes to all prompts)
mise prune --yes

# List managed installs & versions
mise list

