#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zsh/update
# --------------------------------------------------------------------------- #

# Source all update files.
function update() {
    echo "----------------------------------"
    for f in $DOTFILES/*/update.zsh; do
        [[ "$f" == */_apple/update.zsh ]] && continue
        source $f
        echo "----------------------------------"
    done

    # Apple updates last — prompts for each available update
    source $DOTFILES/_apple/update.zsh
    echo "----------------------------------"

    whence neofetch &>/dev/null && neofetch
}
