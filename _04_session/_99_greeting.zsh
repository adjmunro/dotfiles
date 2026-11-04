#!/usr/bin/env zsh

# ------------------------------------------------------------ #
#       [ZSH]   zsh/session
#               last script when initialising a new session
# ------------------------------------------------------------ #

# Clear screen & Neofetch on Terminal Startup
whence cls &>/dev/null && cls
$SYS_INFO

# Printout of custom environment args
colour "$fg_bold[green]" "Local Config:"
[[ $MACHINE ]] && colour "$fg[white]"   "\n  machine  = $MACHINE"
[[ $DOTFILES ]] && colour "$fg[white]"  "\n  dotfiles = $DOTFILES"
[[ $JAVA_HOME ]] && colour "$fg[white]" "\n  java($JAVA_VERSION) = $JAVA_HOME" || error "\n  java     = JDK NOT SET"

# If we're inside a git repo, show the trunk branch.
if whence git &>/dev/null && git rev-parse --is-inside-work-tree &>/dev/null; then
    if whence trunk &>/dev/null; then
        colour "$fg[white]"             "\n  trunk    = $(trunk)"
    fi
fi

# Newline (removes '%' symbol)
print ""

