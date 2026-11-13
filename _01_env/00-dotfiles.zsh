#!/usr/bin/env zsh

# Is a program installed? E.g. installed x || skip
function installed() { whence "$1" &>/dev/null }

# Some things are noisy or create confusion for LLM agents.
# Gating on interactive shells can help.
function human() { [[ -o interactive ]] }

# Cross-platform guard checks
function macos() { [[ $OSTYPE == darwin* ]] }
function linux() { [[ $OSTYPE == linux* ]] }

# Keep $path (and so PATH) free of duplicates: first occurrance wins.
typeset -gU path

# Prepend directories to PATH (also can move an existing entry to the front).
function prepath() { path=("$@" $path) }

# Append directories to PATH (any existing entry keeps its original place).
function postpath() { path+=("$@") }
