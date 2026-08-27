#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   zsh-abbr/init
# --------------------------------------------------------------------------- #

# Unified alias/abbr definition helper.
# Usage: a name="expansion"
return 0
typeset -gi DOTFILES_HAS_ABBR=0
export ABBR_USER_ABBREVIATIONS_FILE="${ABBR_USER_ABBREVIATIONS_FILE:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh-abbr/user-abbreviations}"

function _abbr_run() {
    (( DOTFILES_HAS_ABBR )) || return 1

    if [[ "${ABBR_VERBOSE:-0}" == "1" ]]; then
        abbr "$@"
    else
        ABBR_QUIET=1 ABBR_QUIETER=1 abbr "$@"
    fi
}

function _abbr_add_session() {
    local type="$1"
    local definition="$2"
    local abbreviation="${definition%%=*}"
    local abbreviation_key="${(qqq)${(Q)abbreviation}}"
    local -a abbr_args=(--session)

    if [[ "$type" == "global" ]]; then
        abbr_args+=(--global)
        (( ${+ABBR_GLOBAL_SESSION_ABBREVIATIONS[$abbreviation_key]} )) && return 0
    else
        (( ${+ABBR_REGULAR_SESSION_ABBREVIATIONS[$abbreviation_key]} )) && return 0
    fi

    _abbr_run "${abbr_args[@]}" add -- "$definition"
}

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

    if installed abbr; then
        DOTFILES_HAS_ABBR=1

        debug "%-24s %s\n" "${0:t}" "loaded zsh-abbr v6 from $abbr_script"

        # Define both aliases and session abbreviations. Aliases keep shell
        # usage working in functions and scripts; abbreviations provide
        # interactive expansion in the command line editor.
        function a() {
            alias "$@"

            (( $# == 1 )) || return 0
            _abbr_add_session regular "$1"
        }

        function realias-abbr() {
            local rebind='[[ -f ~/.zshenv ]] && source ~/.zshenv; [[ -f ~/.zshrc ]] && source ~/.zshrc'

            _abbr_run clear-session
            unalias -m '*' 2>/dev/null
            unfunction -m '*' 2>/dev/null
            eval "$rebind"
        }

        function realias() {
            realias-abbr "$@"
        }
    else
        warn "%-24s %s\n" "${0:t}" "sourced $abbr_script but 'abbr' is still unavailable"
    fi
else
    debug "%-24s %s\n" "${0:t}" "zsh-abbr not installed; using alias fallback"
fi

a "e abbr"="e $ABBR_USER_ABBREVIATIONS_FILE"
a "rm abbr"="rm -rfd ${ABBR_USER_ABBREVIATIONS_FILE:h}"

if (( DOTFILES_HAS_ABBR )); then
    # `--` is valid for zsh-abbr v6, but not for alias.
    _abbr_add_session global "--=cd -"
else
    alias -- -='cd -'
fi

# Clear all abbreviations for the current session.
function abbr-clear() {
    if (( ! DOTFILES_HAS_ABBR )); then
        return 0
    fi

    _abbr_run clear-session
}
