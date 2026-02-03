#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zsh-abbr/init   
# --------------------------------------------------------------------------- #

# Source zsh-abbr (needs to happen first, so that abbr exists)
# Supports Homebrew on Apple Silicon and Intel.
local abbr_script=""
if [[ -f /opt/homebrew/share/zsh-abbr/zsh-abbr.zsh ]]; then
    abbr_script="/opt/homebrew/share/zsh-abbr/zsh-abbr.zsh"
elif [[ -f /usr/local/share/zsh-abbr/zsh-abbr.zsh ]]; then
    abbr_script="/usr/local/share/zsh-abbr/zsh-abbr.zsh"
fi

[[ -z "$abbr_script" ]] && return 0

source "$abbr_script"

# Store user abbreviations in XDG config by default.
export ABBR_USER_ABBREVIATIONS_FILE="${ABBR_USER_ABBREVIATIONS_FILE:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh-abbr/user-abbreviations}"

# Unified alias/abbr definition helper.
# Usage: a name="expansion"
# Set ABBR_VERBOSE=1 to allow abbr output.
function a() {
    alias "$@"
}

# If zsh-abbr is available, redefine helper to use abbreviations.
if whence abbr &>/dev/null; then
    function a() {
        if [[ "${ABBR_VERBOSE:-0}" == "1" ]]; then
            abbr --force "$@"
        else
            ABBR_QUIET=1 ABBR_QUIETER=1 abbr --force "$@"
        fi
    }
fi
