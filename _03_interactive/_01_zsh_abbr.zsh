#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zsh-abbr/init
# --------------------------------------------------------------------------- #

# Unified alias/abbr definition helper.
# Usage: a name="expansion"

typeset -gi DOTFILES_HAS_ABBR=0
export ABBR_USER_ABBREVIATIONS_FILE="${ABBR_USER_ABBREVIATIONS_FILE:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh-abbr/user-abbreviations}"

# Source zsh-abbr (needs to happen first, so that abbr exists)
# Supports Homebrew on Apple Silicon and Intel.
local abbr_script=""
if [[ -f /opt/homebrew/share/zsh-abbr/zsh-abbr.zsh ]]; then
    abbr_script="/opt/homebrew/share/zsh-abbr/zsh-abbr.zsh"
elif [[ -f /usr/local/share/zsh-abbr/zsh-abbr.zsh ]]; then
    abbr_script="/usr/local/share/zsh-abbr/zsh-abbr.zsh"
fi

# If abbr script path is a non-zero length string.
if [[ -n "$abbr_script" ]]; then
    source "$abbr_script"

    # If zsh-abbr is available, redefine helper to create both an alias
    # AND an abbreviation. Aliases ensure commands work in functions,
    # scripts, and chained expansions. Abbreviations provide interactive
    # expansion so the user sees the full command before executing.
    if installed abbr; then
        DOTFILES_HAS_ABBR=1
        function a() {
            alias "$@"
            if [[ "${ABBR_VERBOSE:-0}" == "1" ]]; then
                abbr --force "$@"
            else
                ABBR_QUIET=1 ABBR_QUIETER=1 abbr --force "$@"
            fi
        }
    fi
else
    function a() {
         alias "$@"
    }
fi


a "e abbr"="e $ABBR_USER_ABBREVIATIONS_FILE"
a "rm abbr"="rm -rfd ${ABBR_USER_ABBREVIATIONS_FILE:h}"

# `--` is valid for abbr, but not for alias.
if (( DOTFILES_HAS_ABBR )); then
    if [[ "${ABBR_VERBOSE:-0}" == "1" ]]; then
        abbr --force --="cd -"
    else
        ABBR_QUIET=1 ABBR_QUIETER=1 abbr --force --="cd -"
    fi
else
    alias -- -='cd -'
fi

# Clear all abbreviations for the current session.
function abbr-clear() {
    if (( ! DOTFILES_HAS_ABBR )); then
        return 0
    fi

    if [[ "${ABBR_VERBOSE:-0}" == "1" ]]; then
        abbr clear-session
    else
        ABBR_QUIET=1 ABBR_QUIETER=1 abbr clear-session
    fi
}
