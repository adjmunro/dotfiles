#!/usr/bin/env zsh

# Is a program installed? E.g. installed x || skip
function installed() { whence "$1" &>/dev/null }

# Export non-duplicates to PATH
function path() { typeset -gU path "$1" }

