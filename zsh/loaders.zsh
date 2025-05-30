#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zsh/loaders   
#               file iterators for sourcing files 
# --------------------------------------------------------------------------- #

local DIR="$DOTFILES/zsh"

# ------------------------------
#   Load core utilities
# ------------------------------
function SourceCore() {
    for f in $DIR/*.zsh; do
        debug "Source $f"
        source $f;
    done;
    echo "";
}

# ------------------------------
#   Load all alias files
# ------------------------------
function SourceAlias() {
    for f in $DIR/*/alias.zsh; do
        debug "Source $f"
        source $f;
    done;
    echo "";
}

# ------------------------------
#   Load all login files
# ------------------------------
function SourceLogin() {
    for f in $DIR/*/login.zsh; do
        debug "Source $f"
        source $f;
    done;
    echo "";
}

