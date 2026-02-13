#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   aerospace/alias.zsh   
# --------------------------------------------------------------------------- #

# Check that aerospace is installed
whence aerospace &>/dev/null || return false 

a .aerospace="$EDITOR $DOTFILES/dot-config/aerospace/aerospace.toml"

# Quick reference for aerospace key bindings
tileguide() {
  # Try multiple config locations
  if [[ -f "${HOME}/.config/aerospace/aerospace.toml" ]]; then
    CONFIG="${HOME}/.config/aerospace/aerospace.toml"
  elif [[ -f "${HOME}/.aerospace.toml" ]]; then
    CONFIG="${HOME}/.aerospace.toml"
  else
    echo "Config not found"
    return 1
  fi

  # Parse keybinding from config by command pattern
  local parse_binding() {
    local pattern="$1"
    local result=$(grep -E "^\s*[a-z0-9-]+\s*=\s*['\"]${pattern}" "$CONFIG" | \
      head -1 | \
      awk -F'=' '{print $1}' | \
      tr -d ' ' | \
      sed 's/alt-shift-/opt-shift-/g; s/^alt-/opt-/g; s/-semicolon$/-colon/g')
    echo "$result"
  }

  # Parse direction keys (hjkl pattern)
  local parse_hjkl() {
    local cmd="$1"
    local prefix=""
    if [[ "$cmd" == "move" ]]; then
      prefix="shift-"
    fi
    local h=$(parse_binding "${cmd} left" | sed "s/opt-${prefix}//")
    local j=$(parse_binding "${cmd} down" | sed "s/opt-${prefix}//")
    local k=$(parse_binding "${cmd} up" | sed "s/opt-${prefix}//")
    local l=$(parse_binding "${cmd} right" | sed "s/opt-${prefix}//")
    echo "${h}/${j}/${k}/${l}"
  }

  # Extract actual bindings from config
  local focus_keys=$(parse_hjkl "focus" | sed 's/left/←/g; s/down/↓/g; s/up/↑/g; s/right/→/g')
  local move_keys=$(parse_hjkl "move" | sed 's/left/←/g; s/down/↓/g; s/up/↑/g; s/right/→/g')
  local resize_shrink=$(parse_binding "resize smart -50" | sed 's/opt-//')
  local resize_grow=$(parse_binding "resize smart [+]50" | sed 's/opt-//; s/equal/plus/')
  local balance=$(parse_binding "balance-sizes" | sed 's/equal/equals/')
  local fullscreen=$(parse_binding "fullscreen")
  local tiles=$(parse_binding "layout tiles")
  local accordion=$(parse_binding "layout accordion")
  local ws_toggle=$(parse_binding "workspace-back-and-forth")
  local ws_move=$(parse_binding "move-workspace-to-monitor")
  local service_mode=$(parse_binding "mode service")

  # Colors using zsh color codes
  local C_CYAN=$'\e[96m'
  local C_YELLOW=$'\e[93m'
  local C_GREEN=$'\e[92m'
  local C_MAGENTA=$'\e[95m'
  local C_GRAY=$'\e[90m'
  local C_BOLD=$'\e[1m'
  local C_RESET=$'\e[0m'

  # Helper function to get visible length (excluding ANSI codes)
  local visible_len() {
    local str="$1"
    # Remove ANSI escape sequences using sed
    local clean=$(echo -n "$str" | sed 's/\x1b\[[0-9;]*m//g')
    echo "${#clean}"
  }

  # Helper function to print formatted line with proper alignment
  local print_line() {
    local label="$1"
    local keybind="$2"
    local desc="$3"

    # Calculate visible lengths
    local label_len=$(visible_len "$label")
    local keybind_len=$(visible_len "$keybind")

    # Target widths for columns
    local label_width=15
    local keybind_width=30

    # Calculate padding needed
    local label_pad=$((label_width - label_len))
    local keybind_pad=$((keybind_width - keybind_len))

    # Print with proper spacing
    printf "${C_BOLD}${C_YELLOW}%s${C_RESET}%*s" "$label" "$label_pad" ""
    printf "${C_CYAN}%s${C_RESET}%*s" "$keybind" "$keybind_pad" ""
    printf "${C_GRAY}%s${C_RESET}\n" "$desc"
  }

  print -r "${C_BOLD}${C_MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
  print -r "${C_BOLD}${C_MAGENTA}AeroSpace Quick Reference${C_RESET}"
  print -r "${C_BOLD}${C_MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
  print -r ""
  print_line "Focus" "opt-${C_GREEN}[${focus_keys}]${C_CYAN}" "move focus"
  print_line "Move" "opt-shift-${C_GREEN}[${move_keys}]${C_CYAN}" "move window"
  print -r ""
  print_line "Resize" "opt-${resize_shrink} / ${resize_grow}" "shrink/grow"
  print_line "Balance" "${balance}" "balance sizes"
  print_line "Fullscreen" "${fullscreen}" "toggle"
  print -r ""
  print_line "Tiles Mode" "${tiles}" "cycle horiz ↔ vert"
  print_line "Accordion" "${accordion}" "cycle horiz ↔ vert"
  print -r ""
  print_line "Workspace" "opt-${C_GREEN}[1-9]${C_CYAN}, opt-${C_GREEN}[a-z]${C_CYAN}" "switch workspace"
  print_line "Assign" "opt-shift-${C_GREEN}[1-9/a-z]${C_CYAN}" "move window to workspace"
  print_line "Switch" "${ws_toggle}" "back & forth"
  print_line "Move Monitor" "${ws_move}" "workspace to next monitor"
  print -r ""
  print_line "Reload" "${service_mode} ${C_GREEN}esc${C_CYAN}" "reload config"
  print_line "Service" "${service_mode} ${C_GREEN}r${C_CYAN}" "reset layout"
  print_line "" "${service_mode} ${C_GREEN}f${C_CYAN}" "toggle floating"
}

# Regenerate tileguide after config changes
alias reload-aerospace='aerospace reload-config && echo "Config reloaded. Run tileguide for updated reference."'

