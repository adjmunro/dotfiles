#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zsh-abbr/init   
# --------------------------------------------------------------------------- #

# Unified alias/abbr definition helper.
# Usage: a name="expansion"

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

    # Store user abbreviations in XDG config by default.
    export ABBR_USER_ABBREVIATIONS_FILE="${ABBR_USER_ABBREVIATIONS_FILE:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh-abbr/user-abbreviations}"

    # If zsh-abbr is available, redefine helper to create both an alias
    # AND an abbreviation. Aliases ensure commands work in functions,
    # scripts, and chained expansions. Abbreviations provide interactive
    # expansion so the user sees the full command before executing.
    if whence abbr &>/dev/null; then
        function a() {
            alias "$@"
            if [[ "${ABBR_VERBOSE:-0}" == "1" ]]; then
                abbr --force "$@"
            else
                ABBR_QUIET=1 ABBR_QUIETER=1 abbr --force "$@"
            fi
        }
    else
        function a() {
            alias "$@"
        }
    fi
fi
