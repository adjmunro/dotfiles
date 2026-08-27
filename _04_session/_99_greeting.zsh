#!/usr/bin/env zsh

# ------------------------------------------------------------ #
#       [ZSH]   zsh/session
#               last script when initialising a new session
# ------------------------------------------------------------ #

# Clear screen & Neofetch on Terminal Startup
whence cls &>/dev/null && cls
$SYS_INFO

# Printout of custom environment args
colour "$fg_bold[white]" "Local Config:\n"
print "  dotfiles = $DOTFILES"
print "  machine  = $MACHINE"


# If we're inside a git repo, show the trunk branch.
if whence git &>/dev/null && git rev-parse --is-inside-work-tree &>/dev/null; then
    if whence trunk &>/dev/null; then
        print "  trunk    = $(trunk)"
    fi
fi

# As my final act, tone down the logging.
export LOG_LEVEL=LOG_WARN
