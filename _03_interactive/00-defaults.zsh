#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#               Define default operations read/write/ls/nav etc.
# --------------------------------------------------------------------------- #

# Default text editor
export ALIAS=(builtin alias)
alias alias='$ALIAS'             # Clarity
alias a='$ALIAS'                 # Shorthand

# --------------------------------------------------------------------------- #

# Default text editor
export EDITOR="vim"
alias edit='$EDITOR'            # Clarity
alias e='$EDITOR'               # Shorthand

# --------------------------------------------------------------------------- #

# Default "file browser"
export FILE_BROWSER="vim"
alias files='$FILE_BROWSER'
alias fb='$FILE_BROWSER'

# --------------------------------------------------------------------------- #

# Default "list directory contents"
export LIST_DIRECTORY=(command ls)
alias list='$LIST_DIRECTORY'    # Clarity
alias lh='command ls -ACFG'     # Vertical Fallback
alias lv='command ls -ohGAF'    # Horizontal Fallback

# Only replace 'ls' for humans -- it confuses LLM agents.
function ls() {
    if human; then
        $LIST_DIRECTORY $@
    else;
        command ls "$@"
    fi
}

# --------------------------------------------------------------------------- #

# Display system information
export SYS_INFO=""          # No-op
alias sys='$SYS_INFO'

# --------------------------------------------------------------------------- #

# Default "view file"
export VIEW="cat"
alias view='$VIEW'              # Clarity
alias v='$VIEW'                 # Shorthand
