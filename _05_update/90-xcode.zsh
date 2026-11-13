#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Check that Xcode is installed
[[ -d /Applications/Xcode.app ]] || return $SKIP_DOTFILE

# --------------------------------------------------------------------------- #

info "=== Xcode ===\n"

# Use Xcode's toolchain rather than the standalone Command Line Tools.
[[ "$(xcode-select -p)" == /Applications/Xcode.app/* ]] || sudo xcode-select --switch /Applications/Xcode.app

# After an Xcode install/update: install its components and accept the licence.
# -checkFirstLaunchStatus exits non-zero when that is still pending.
xcodebuild -checkFirstLaunchStatus || sudo xcodebuild -runFirstLaunch -checkForNewerComponents

# Download an iOS simulator runtime if this Xcode has none.
xcrun simctl list runtimes | grep -q '^iOS' || xcodebuild -downloadPlatform iOS

