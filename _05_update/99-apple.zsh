#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

info "=== Update Apple Software ===\n"

# List available updates (progress noise goes to stderr)
local updates_raw
updates_raw=$(softwareupdate --list 2>/dev/null)

# Bail early if nothing available
if print "$updates_raw" | grep -q "No new software available"; then
    warn "No Apple software updates available.\n"
    return 0
fi

# Parse labels and titles into parallel arrays.
# softwareupdate --list format:
#    * Label: Command Line Tools for Xcode-16.0
#      Title: Command Line Tools for Xcode 16.0, Version: 16.0, ...
local labels=()
local titles=()
local current_label=""
local label_pat='^[[:space:]]*\*[[:space:]]+Label:[[:space:]]+(.+)$'
local title_pat='Title:[[:space:]]+([^,]+)'

while IFS= read -r line; do
    if [[ "$line" =~ $label_pat ]]; then
        current_label="${match[1]}"
        labels+=("$current_label")
    elif [[ -n "$current_label" && "$line" =~ $title_pat ]]; then
        titles+=("${match[1]}")
        current_label=""
    fi
done <<< "$updates_raw"

if [[ ${#labels[@]} -eq 0 ]]; then
    warn "No Apple software updates available.\n"
    return 0
fi

info "Apple software updates available:\n"
local to_install=()

for i in $(seq 1 ${#labels[@]}); do
    local label="${labels[$i]}"
    local title="${titles[$i]:-$label}"
    print -n "  Install '$title'? [y/N] "
    read -r response
    [[ "${response:l}" == "y" ]] && to_install+=("$label")
done

if [[ ${#to_install[@]} -eq 0 ]]; then
    info "No updates selected.\n"
    return 0
fi

for label in "${to_install[@]}"; do
    info "Installing: $label\n"
    softwareupdate --install "$label" --agree-to-license
done
