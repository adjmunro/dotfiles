#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zsh/update
# --------------------------------------------------------------------------- #

# Source all update files.
function update() {
    print  "----------------------------------"
    for f in $DOTFILES/_05_update/*.zsh; do
        source $f
        print  "----------------------------------"
    done

    $SYS_INFO
}
