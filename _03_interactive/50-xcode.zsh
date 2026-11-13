#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Check that Xcode is installed
[[ -d /Applications/Xcode.app ]] || return $SKIP_DOTFILE

# --------------------------------------------------------------------------- #

# xcodebuild for scripts/agents: skip plugin/macro trust prompts and network package resolution
a xcb="xcodebuild -skipPackagePluginValidation -skipMacroValidation -disableAutomaticPackageResolution"
