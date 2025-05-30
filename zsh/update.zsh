#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zsh/update   
# --------------------------------------------------------------------------- #

# Source all update files.
function update() {
    debug "----------------------------------"
    for f in $DOTFILES/zsh/*/update.zsh; do
        source $f;
        debug "----------------------------------"
    done;

    require neofetch && neofetch
}

