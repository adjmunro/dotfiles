#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zsh/theme
#               terminal emulator theme management
# --------------------------------------------------------------------------- #

if [[ $TERM_PROGRAM == "ghostty" ]]; then
    whence oh-my-posh &>/dev/null || return false

    eval "$(oh-my-posh init zsh)"
    #export POSH_THEME="$DOTFILES/dot-config/oh-my-posh/themes/00-MainTheme.toml"
    #eval "$(oh-my-posh init zsh --config $POSH_THEME)"
fi
