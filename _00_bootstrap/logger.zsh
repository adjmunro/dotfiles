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

# Export the default logging level
export LOG_LEVEL=LOG_VERBOSE

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

function error() { (( ${LOG_LEVEL:-0} >= LOG_ERROR )) && colour "$fg_bold[red]" $@ }
function warn() { (( ${LOG_LEVEL:-0} >= LOG_WARN )) && colour "$fg[yellow]" $@ }
function info() { (( ${LOG_LEVEL:-0} >= LOG_INFO )) && colour "$fg[green]" $@ }
function debug() { (( ${LOG_LEVEL:-0} >= LOG_DEBUG )) && colour "$fg[white]" $@ }
function verbose() { (( ${LOG_LEVEL:-0} >= LOG_VERBOSE )) && colour "$fg[black]" $@ }

function colours() {
    for c in ${(k)fg}; do
    printf '%b%-12s%b' "$fg[$c]" "fg $c" "$reset_color"
    printf '%b%-12s%b' "$fg_bold[$c]" "bold $c" "$reset_color"
    printf '%b%-12s%b' "$bg[$c]" "bg $c" "$reset_color"
    printf '%b%-12s%b\n' "$bg_bold[$c]" "bold $c" "$reset_color"
    done
}
