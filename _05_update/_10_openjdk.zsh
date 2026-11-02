#!/usr/bin/env zsh

# --------------------------------------------------------------------------- #

# Check that Homebrew is installed
[[ -d $HOMEBREW_OPT ]] || return $SKIP_DOTFILE

# --------------------------------------------------------------------------- #

info "=== Register Homebrew JDKs ===\n"

# Homebrew JDKs are keg-only, so macOS can't see them. Linking them here lets
# /usr/libexec/java_home, /usr/bin/java and Gradle's toolchain detection find them.
local jvms=/Library/Java/JavaVirtualMachines
local keg link
for keg in $HOMEBREW_OPT/openjdk@<->(N/); do
    link="$jvms/openjdk-${${keg:t}#openjdk@}.jdk"      # openjdk@25 -> openjdk-25.jdk
    [[ -e $link ]] || sudo ln -sfn "$keg/libexec/openjdk.jdk" "$link"
done

# Remove links whose JDK has since been uninstalled (dangling symlinks).
for link in $jvms/openjdk-*.jdk(N-@); do
    sudo rm "$link"
done

