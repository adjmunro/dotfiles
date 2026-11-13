#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Check that oh-my-posh is installed.
installed oh-my-posh || return $SKIP_DOTFILE

# --------------------------------------------------------------------------- #

# Use the theme file in $POSH_THEME if set (e.g. in _local.zsh), otherwise
# oh-my-posh's default theme.
if [[ $TERM_PROGRAM == "ghostty" ]]; then
    if [[ -f $POSH_THEME ]]; then
        eval "$(oh-my-posh init zsh --config $POSH_THEME)"
    else
        eval "$(oh-my-posh init zsh)"
    fi
fi
