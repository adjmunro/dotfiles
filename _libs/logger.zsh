#!/usr/bin/env zsh
autoload -Uz colors && colors

# --------------------------------------------------------------------------- #

# Initialises read-only [-r] environment variables. These cannot be
# changed in the current session unless the shell session is restarted.

# Define the available logging levels
(( ${+LOG_SILENT} )) || typeset -r LOG_SILENT=0
(( ${+LOG_ERROR} )) || typeset -r LOG_ERROR=1
(( ${+LOG_WARN} )) || typeset -r LOG_WARN=2
(( ${+LOG_INFO} )) || typeset -r LOG_INFO=3
(( ${+LOG_DEBUG} )) || typeset -r LOG_DEBUG=4
(( ${+LOG_VERBOSE} )) || typeset -r LOG_VERBOSE=5

# --------------------------------------------------------------------------- #

function colour() {
    # Pop arg 1
    local color=$1
    shift

    # Pop arg 2
    local fmt=$1
    shift

    # Wrap the remaining args in the color
    printf '%b'"$fmt"'%b' "$color" "$@" "$reset_color"
}

function error() { (( ${LOG_LEVEL:-0} >= LOG_ERROR )) || return 0; colour >&2 "$fg_bold[red]" $@ }
function warn() { (( ${LOG_LEVEL:-0} >= LOG_WARN )) || return 0; colour >&2 "$fg[yellow]" $@ }
function info() { (( ${LOG_LEVEL:-0} >= LOG_INFO )) || return 0; colour "$fg[green]" $@ }
function debug() { (( ${LOG_LEVEL:-0} >= LOG_DEBUG )) || return 0; colour "$fg[white]" $@ }
function verbose() { (( ${LOG_LEVEL:-0} >= LOG_VERBOSE )) || return 0; colour "$fg[black]" $@ }

function colours() {
    for c in ${(k)fg}; do
    printf '%b%-12s%b' "$fg[$c]" "fg $c" "$reset_color"
    printf '%b%-12s%b' "$fg_bold[$c]" "bold $c" "$reset_color"
    printf '%b%-12s%b' "$bg[$c]" "bg $c" "$reset_color"
    printf '%b%-12s%b\n' "$bg_bold[$c]" "bold $c" "$reset_color"
    done
}

# --------------------------------------------------------------------------- #

# Export the default logging level
if [[ ! -o interactive ]]; then
    # Only log errors for non-interactive shells (LLM agents) 
    typeset -g +x LOG_LEVEL=LOG_ERROR
else
    # If not already set in interactive shells:
    # default to verbose logging and warn the user! 
    if (( ! ${+LOG_LEVEL} )); then
         typeset -g LOG_LEVEL=LOG_VERBOSE
         warn "LOG_LEVEL has not been set! Export it in '$DOTFILES/_local.zsh'\n"
    fi
fi

