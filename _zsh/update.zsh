#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zsh/update
# --------------------------------------------------------------------------- #

# Source all update files.
function update() {
    echo "----------------------------------"
    for f in $DOTFILES/*/update.zsh; do
        source $f;
        echo "----------------------------------"
    done;

    whence neofetch &>/dev/null && neofetch
}
