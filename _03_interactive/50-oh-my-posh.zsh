#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   oh-my-posh/alias
# --------------------------------------------------------------------------- #

# Check that oh-my-posh is installed
installed oh-my-posh || return $SKIP_DOTFILE

a omp="oh-my-posh"

# Pick an oh-my-posh theme for this session, from the dotfiles' own themes
# and those bundled with oh-my-posh. To keep one, set POSH_THEME in _local.zsh.
function posh-theme() {
    local themes=(
        $DOTFILES/dot-config/oh-my-posh/themes/*.(toml|json|yaml)(N)
        $(brew --prefix oh-my-posh)/themes/*.omp.*(N)
    )
    local theme
    select theme in ${themes:t}; do
        [[ -n $theme ]] || continue
        export POSH_THEME=${themes[(r)*/$theme]}
        eval "$(oh-my-posh init zsh --config $POSH_THEME)"
        print "POSH_THEME=$POSH_THEME"
        break
    done
}
