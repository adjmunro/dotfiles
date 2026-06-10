#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   homebrew/alias
# --------------------------------------------------------------------------- #

# Check that homebrew is installed
installed brew || return $SKIP_DOTFILE

a brewing="brew ls --versions"


function summon() {
  if [[ -z "$1" ]]; then
    print  "Usage: summon <package>"
    return 1
  fi

  local pkg="$1"

  brew info "$pkg" || return 1

  echo
  read "?Install $pkg? [y/N] " reply

  if [[ "$reply" =~ ^[Yy]$ ]]; then
    brew install "$pkg"
  else
    print  "Aborted."
  fi
}
