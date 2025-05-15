#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zsh/logging
#               custom printout functions
# --------------------------------------------------------------------------- #

export DEBUG=false

# Echo arguments only in verbose mode.
function debug() {
    # Check that verbose mode is enabled. 
    if [ "$DEBUG" = true ]; then
        # Pass all arguments ($@) to echo 
        echo "$@"
    fi
}

function error() {
    # Pass all arguments ($@) to echo stderr (>&2)
    echo >&2 "$@"
    
    # Return error status code
    return 1
}

