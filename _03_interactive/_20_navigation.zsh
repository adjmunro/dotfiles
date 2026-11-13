#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Default "change directory"
# Only replace 'cd' for humans -- it confuses LLM agents.
function cd {
    if human; then
        builtin cd "$@" && list
    else;
        builtin cd "$@"
    fi
}

# Navigate up to parent directory
a ..="cd .."

# Navigate up to grandparent directory
a ...="cd ../.."

# Open key directories in the default navigator
a .="$FILE_BROWSER ."
a home="$FILE_BROWSER $HOME"
a downloads="$FILE_BROWSER $HOME/Downloads"
a desktop="$FILE_BROWSER $HOME/Desktop"
a docs="$FILE_BROWSER $HOME/Documents"
a pics="$FILE_BROWSER $HOME/Pictures"
a dev="$FILE_BROWSER $HOME/Developer"
