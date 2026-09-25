#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Default "change directory"
function cd { builtin cd "$@" && list }

# Fallback access to the old cd in case something breaks
a cd-old='command cd'

# Navigate up to parent directory
a ..="cd .."

# Navigate up to grandparent directory
a ...="cd ../.."

# Open key directories in the default navigator
a home="$NAVIGATOR $HOME"
a downloads="$NAVIGATOR $HOME/Downloads"
a desktop="$NAVIGATOR $HOME/Desktop"
a docs="$NAVIGATOR $HOME/Documents"
a pics="$NAVIGATOR $HOME/Pictures"
a dev="$NAVIGATOR $HOME/Developer"
