#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   mise/update   
# --------------------------------------------------------------------------- #

debug "Update Mise Version Manager"

# Clean mise cache (precaution)
fix-mise

# Upgrade versions
mise upgrade

# Prune old versions (yes to all prompts)
mise prune --yes

# List managed installs & versions
mise list

