#!/usr/bin/env zsh

# ------------------------------------------------------------ #
#       [ZSH]   zsh/init
#               last script when initialising a new session
# ------------------------------------------------------------ #

# Clear screen & Neofetch on Terminal Startup
cls && neofetch

# Printout of custom environment args
echo "Local Config:"
echo "  machine  = $MACHINE"
echo "  dotfiles = $DOTFILES"
echo "  project  = $PROJECT"

