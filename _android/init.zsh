#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #
#       [ZSH]   android/init   
# --------------------------------------------------------------------------- #

# Check that Android Studio is installed
whence ~/Applications/Android\ Studio.app/Contents/MacOS/studio &>/dev/null || return false 

# ------------------------------
#   Export locations to PATH
# ------------------------------
# Note these are the Android Studio packaged tools. 
# You can also `brew install --cask android-platform-tools` which would be in /opt/homebrew/bin
export ANDROID_STUDIO_HOME=~/Applications/Android\ Studio.app/Contents
export ANDROID_HOME=~/Library/Android/sdk
export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$ANDROID_HOME/cmdline-tools/latest/bin"

