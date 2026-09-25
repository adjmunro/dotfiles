#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#               Define default operations read/write/ls/nav etc.
# --------------------------------------------------------------------------- #

# Display system information
export SYS_INFO=""          # No-op

# --------------------------------------------------------------------------- #

# Default text editor
export EDITOR="vim"
a edit='$EDITOR'            # Clarity
a e='$EDITOR'               # Shorthand

# --------------------------------------------------------------------------- #

# Default "view file"
export VIEW="cat"
a view='$VIEW'              # Clarity
a v='$VIEW'                 # Shorthand

# --------------------------------------------------------------------------- #

# Default "list directory contents"
export LIST_DIRECTORY=(command ls)
a list='$LIST_DIRECTORY'    # Clarity

# Don't replace 'ls' -- it confuses the agents.
a ll='$LIST_DIRECTORY'      # Shorthand
a lh='command ls -ACFG'     # Vertical Fallback
a lv='command ls -ohGAF'    # Horizontal Fallback

# --------------------------------------------------------------------------- #

# Default "file system navigator"
export NAVIGATOR="vim"
a nav='$NAVIGATOR'
