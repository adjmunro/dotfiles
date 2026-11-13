#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Note: there are also dotless, system-wide variants in /etc.
# These system-wide variants are always run *before* their user-specific
# counterparts (except /etc/zlogout, which is *after* ~/.zlogout).

# (1) Zsh Environment
# Always source for every invocation (login, interactive, & script)
# Used for user-specific environment variables
# !! Should be kept lean & fast!
a .zshenv="$EDITOR $DOTFILES/dot-zshenv"

# (-) Custom machine args (sourced by .zshenv)
a .zlocal="$EDITOR $DOTFILES/_local.zsh"

# (2) Zsh Profile
# Sourced for login shells after zshenv
# Used for user-specific login shell configurations
a .zprofile="$EDITOR $DOTFILES/dot-zprofile"

# (3) Zsh Resource Config
# Sourced for interactive shells after zprofile
# Used for user-specific interactive shell configurations
a .zshrc="$EDITOR $DOTFILES/dot-zshrc"

# (4) Zsh Login
# Sourced for login shells after all others
# Used for user-specific login commands
a .zlogin="$EDITOR $DOTFILES/dot-zlogin"

# (5) Zsh Logout
# Sourced for login shells after the shell exists
# Used for cleanup tasks
# Sourced before /etc/zlogout
a .zlogout="$EDITOR $DOTFILES/dot-zlogout"

# --------------------------------------------------------------------------- #

# Print "file:line" where an alias or function was defined.
# Aliases are recorded by the `alias` wrapper in _00_alias.zsh; functions come
# from zsh's own $functions_source, with the line found by searching the file.
function _dotfiles_where() {
    emulate -L zsh
    setopt extended_glob
    zmodload zsh/parameter

    local name=$1
    [[ -n $name ]] || { print -u2 "usage: dotfiles --where <alias|function>"; return 1 }

    # Ask zsh what the name resolves to, as that's what actually runs.
    local kind=$(whence -w -- "$name")
    kind=${kind##*: }
    case $kind in
        (alias|global\ alias|suffix\ alias)
            local src=${DOTFILES_ALIAS_SOURCE[$name]}
            [[ -n $src ]] || { print -u2 "dotfiles: '$name' is an alias, but its source wasn't recorded"; return 1 }
            print -r -- $src
            ;;
        (function)
            local file=${functions_source[$name]}
            [[ -f $file ]] || { print -u2 "dotfiles: '$name' is a function, but its source is unknown"; return 1 }

            # Match `function name`, `function name()` or `name()`.
            local line
            local -i i=0
            while IFS= read -r line; do
                (( ++i ))
                if [[ $line == [[:space:]]#(function[[:space:]]##${name}([[:space:]\(\{]*|)|${name}[[:space:]]#\(\)*) ]]; then
                    print -r -- "$file:$i"
                    return 0
                fi
            done < $file
            print -r -- $file
            ;;
        (none)
            print -u2 "dotfiles: '$name' not found"
            return 1
            ;;
        (*)
            print -u2 "dotfiles: '$name' is a $kind, not an alias or function"
            return 1
            ;;
    esac
}

function dotfiles() {
    # No args => open file browser for dotfiles repo.
    if (( $# == 0 )); then
        $NAVIGATOR $DOTFILES;
        return true;
    fi;

    local sub=$1
    case $sub in
        # Fetch the git repo.
        (sync)
            whence git &>/dev/null || return $(err "Git not installed!")
            git --git-dir="$DOTFILES" fetch origin main:main
            ;;

        # Locate an alias/function, then optionally open its file.
        (-w|--where|-v|--view|-e|--edit|-n|--nav)
            local loc
            loc=$(_dotfiles_where "$2") || return
            (( $# > 2 )) && print -u2 "dotfiles: ignoring extra arguments: ${@:3}"

            # Split "file:line" (functions without a found line have no ":N").
            local file=$loc line=
            [[ $loc == *:<-> ]] && { file=${loc%:*}; line=${loc##*:} }

            case $sub in
                (-w|--where) print -r -- $loc ;;
                (-v|--view)  ${=VIEW} $file ;;
                (-n|--nav)   ${=NAVIGATOR} $file ;;
                (-e|--edit)
                    # Most terminal editors accept +N to jump to a line.
                    local -a editor=(${=EDITOR})
                    if [[ -n $line && ${editor[1]:t} == (vi|vim|nvim|nano|emacs|micro) ]]; then
                        $editor +$line $file
                    else
                        $editor $file
                    fi
                    ;;
            esac
            ;;

        (-h|--help)
            print -r -- "usage: dotfiles [sync | -w|--where | -v|--view | -e|--edit | -n|--nav <alias|function>]"
            ;;

        (*)
            print -u2 "dotfiles: unknown option '$sub' (see dotfiles --help)"
            return 1
            ;;
    esac
}
