#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Check that gfind is installed
installed gfind || return $SKIP_DOTFILE

# --------------------------------------------------------------------------- #

### TODO Rework these aliases in terms of core commands or move?

# Prune empty directories
a prune-dirs="gfind -type d -empty -delete"

# Clean up broken symlinks
a prune-links="gfind -xtype l -delete"
