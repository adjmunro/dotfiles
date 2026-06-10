#!/usr/bin/env zsh

# Check that pnpm is installed
[[ -d "$HOME/Library/pnpm" ]] || return $SKIP_DOTFILE

# Export pnpm environment variables
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
