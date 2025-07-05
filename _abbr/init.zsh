#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zsh-abbr/init   
# --------------------------------------------------------------------------- #

# Remove all aliases (ensure latest one is applied)
rm -rfd $ABBR_USER_ABBREVIATIONS_FILE:h

# Source zsh-abbr (needs to happen first, so that abbr exists)
source /opt/homebrew/share/zsh-abbr/zsh-abbr.zsh

