#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zsh/default
#               Define default operations read/write/ls/nav etc.
# --------------------------------------------------------------------------- #

# Default text editor
export EDITOR="vim"
a edit='$EDITOR'            # Clarity
a e='$EDITOR'               # Shorthand

# Default "view file"
export VIEW="cat"
a view='$VIEW'              # Clarity
a v='$VIEW'                 # Shorthand

# Default "list directory contents"
export LIST_DIRECTORY=(command ls)
a list='$LIST_DIRECTORY'    # Clarity
a ls='$LIST_DIRECTORY'      # Shorthand
a ll='command ls'           # Fallback
a lh='command ls -ACFG'     # Vertical Fallback
a lv='command ls -ohGAF'    # Horizontal Fallback

# Display system information
export SYS_INFO=""

# Default "change directory"
function cd { builtin cd "$@" && list }
a cdd='command cd'
