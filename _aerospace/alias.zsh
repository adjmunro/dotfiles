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
  local focus_keys=$(parse_hjkl "focus")
  local move_keys=$(parse_hjkl "move")
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

  print -r "${C_BOLD}${C_MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
  print -r "${C_BOLD}${C_MAGENTA}AeroSpace Quick Reference${C_RESET}"
  print -r "${C_BOLD}${C_MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
  print -r ""
  print -r "${C_BOLD}${C_YELLOW}Focus${C_RESET}          ${C_CYAN}opt-${focus_keys}${C_RESET}           ${C_GRAY}left/down/up/right${C_RESET}"
  print -r "${C_BOLD}${C_YELLOW}Move${C_RESET}           ${C_CYAN}opt-shift-${move_keys}${C_RESET}     ${C_GRAY}move window${C_RESET}"
  print -r ""
  print -r "${C_BOLD}${C_YELLOW}Resize${C_RESET}         ${C_CYAN}opt-${resize_shrink} / ${resize_grow}${C_RESET}      ${C_GRAY}shrink/grow${C_RESET}"
  print -r "${C_BOLD}${C_YELLOW}Balance${C_RESET}        ${C_CYAN}${balance}${C_RESET}      ${C_GRAY}balance sizes${C_RESET}"
  print -r "${C_BOLD}${C_YELLOW}Fullscreen${C_RESET}     ${C_CYAN}${fullscreen}${C_RESET}             ${C_GRAY}toggle${C_RESET}"
  print -r ""
  print -r "${C_BOLD}${C_YELLOW}Tiles Mode${C_RESET}     ${C_CYAN}${tiles}${C_RESET}             ${C_GRAY}cycle horiz ↔ vert${C_RESET}"
  print -r "${C_BOLD}${C_YELLOW}Accordion${C_RESET}      ${C_CYAN}${accordion}${C_RESET}             ${C_GRAY}cycle horiz ↔ vert${C_RESET}"
  print -r ""
  print -r "${C_BOLD}${C_YELLOW}Workspace${C_RESET}      ${C_CYAN}opt-1-9, opt-a-z${C_RESET}      ${C_GRAY}switch workspace${C_RESET}"
  print -r "${C_BOLD}${C_YELLOW}Assign${C_RESET}         ${C_CYAN}opt-shift-1-9/a-z${C_RESET}     ${C_GRAY}move window to workspace${C_RESET}"
  print -r "${C_BOLD}${C_YELLOW}Switch${C_RESET}         ${C_CYAN}${ws_toggle}${C_RESET}               ${C_GRAY}back & forth${C_RESET}"
  print -r "${C_BOLD}${C_YELLOW}Move Monitor${C_RESET}   ${C_CYAN}${ws_move}${C_RESET}         ${C_GRAY}workspace to next monitor${C_RESET}"
  print -r ""
  print -r "${C_BOLD}${C_YELLOW}Reload${C_RESET}         ${C_CYAN}${service_mode}${C_RESET} ${C_GREEN}esc${C_RESET}        ${C_GRAY}reload config${C_RESET}"
  print -r "${C_BOLD}${C_YELLOW}Service${C_RESET}        ${C_CYAN}${service_mode}${C_RESET} ${C_GREEN}r${C_RESET}          ${C_GRAY}reset layout${C_RESET}"
  print -r "${C_BOLD}${C_YELLOW}${C_RESET}               ${C_CYAN}${service_mode}${C_RESET} ${C_GREEN}f${C_RESET}          ${C_GRAY}toggle floating${C_RESET}"
}

# Regenerate tileguide after config changes
alias reload-aerospace='aerospace reload-config && echo "Config reloaded. Run tileguide for updated reference."'

