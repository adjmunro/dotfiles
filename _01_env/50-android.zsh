#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Check if OpenJDK is installed.
export JAVA_VERSION=25
if [[ -d "$HOMEBREW_OPT/openjdk@$JAVA_VERSION" ]]; then
    export JAVA_HOME="$HOMEBREW_OPT/openjdk@$JAVA_VERSION"
    prepath "$JAVA_HOME/bin"
fi

# --------------------------------------------------------------------------- #

# Check that Jetbrains Toolbox is installed.
if [[ -d "$HOME/Library/Application Support/JetBrains/Toolbox" ]]; then
    postpath "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
fi

# --------------------------------------------------------------------------- #

# Check that Android Studio is installed.
local ANDROID_STUDIO="$HOME/Applications/Android Studio.app/Contents"
if installed "$ANDROID_STUDIO/MacOS/studio"; then
    export ANDROID_STUDIO_HOME="$ANDROID_STUDIO"

    # Export Android Studio packaged tools to PATH.
    # You can also `brew install --cask android-platform-tools` which would be in /opt/homebrew/bin
    if [[ -d "$HOME/Library/Android/sdk" ]]; then
        export ANDROID_HOME="$HOME/Library/Android/sdk"
        postpath "$ANDROID_HOME/cmdline-tools/latest/bin"
        postpath "$ANDROID_HOME/emulator"
        postpath "$ANDROID_HOME/platform-tools"
    fi
fi
