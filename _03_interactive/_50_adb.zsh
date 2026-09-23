#!/usr/bin/env zsh

# Check that adb is installed
installed adb || return $SKIP_DOTFILE

function indroid() {
  str=`echo "$@" | sed -r 's/ /%s/g'`
  if [ "$1" != "" ]; then
    adb -d shell input text $str
  else
    echo "Please provide text input to send to the device"
  fi
}
