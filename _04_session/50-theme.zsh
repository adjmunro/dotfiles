#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Check that oh-my-posh is installed.
installed oh-my-posh || return $SKIP_DOTFILE

# --------------------------------------------------------------------------- #

if [[ $TERM_PROGRAM == "ghostty" ]]; then
    eval "$(oh-my-posh init zsh)"
    #export POSH_THEME="$DOTFILES/dot-config/oh-my-posh/themes/00-MainTheme.toml"
    #eval "$(oh-my-posh init zsh --config $POSH_THEME)"
fi
