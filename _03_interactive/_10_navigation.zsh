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
