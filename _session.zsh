#!/usr/bin/env zsh

# ------------------------------------------------------------ #
#       [ZSH]   zsh/session
#               last script when initialising a new session
# ------------------------------------------------------------ #

# Clear screen & Neofetch on Terminal Startup
whence cls &>/dev/null && cls
whence neofetch &>/dev/null && neofetch

# Printout of custom environment args
echo "Local Config:"
echo "  machine  = $MACHINE"
echo "  dotfiles = $DOTFILES"
echo "  project  = $PROJECT"

# If we're inside a git repo, show the trunk branch.
if whence git &>/dev/null && git rev-parse --is-inside-work-tree &>/dev/null; then
    if whence trunk &>/dev/null; then
        echo "  trunk    = $(trunk)"
    fi
fi
