#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zsh/logging
#               custom printout functions
# --------------------------------------------------------------------------- #

# Only export default if not set to true.
if [ "$DEBUG" != true ]; then
    export DEBUG=false
fi;

# Echo arguments only in verbose mode.
function debug() {
    # Check that verbose mode is enabled. 
    if [ "$DEBUG" = true ]; then
        # Pass all arguments ($@) to echo 
        echo "$@"
    fi
}

# Printf arguments only in verbose mode.
function debugf() {
    # Check that verbose mode is enabled. 
    if [ "$DEBUG" = true ]; then
        # Pass all arguments ($@) to echo 
        printf "$@"
    fi
}

function error() {
    # Pass all arguments ($@) to echo stderr (>&2)
    echo >&2 "$@"
    
    # Return error status code
    return 1
}

