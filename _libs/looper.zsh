#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Initialises global [-g], read-only [-r] environment variables. These cannot be
# changed in the current session unless the shell session is restarted.
# If not set, set the unique status code for failed guard conditions.
(( ${+SKIP_DOTFILE} )) || typeset -gr SKIP_DOTFILE=44

# --------------------------------------------------------------------------- #

# Create the function to iteratively source all dotfiles
function source-dir() {
    emulate -L zsh
    setopt null_glob

    local dir="$DOTFILES/$1"
    local file
    local exit_status=0
    local -a files

    files=("$dir"/*.zsh)

    info "\n=== source-dir: ${dir:t} ===\n"

    if (( ${#files} == 0 )); then
        warn "!!! no matches !!!\n"
        return 0
    fi

    for file in "${files[@]}"; do
        source "$file"
        exit_status=$?


        if (( exit_status == 0 )); then
            debug "%-24s %s\n" "${file:t}" "[ok]"
        elif (( exit_status == SKIP_DOTFILE )); then
            warn "%-24s %s\n" "${file:t}" "[skipped]($exit_status::NotInstalled)"
        else
            error "%-24s %s\n" "${file:t}" "[failed]($exit_status)"
        fi
    done

    info "=== done ===\n"
}
