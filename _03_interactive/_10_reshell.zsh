#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Re-source zshenv & zshrc files (only if present)
function reshell() {
    if installed cls; then cls; fi
    [[ -f ~/.zshenv ]] && source ~/.zshenv
    [[ -f ~/.zshrc ]] && source ~/.zshrc
}
