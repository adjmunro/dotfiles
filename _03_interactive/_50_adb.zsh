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

# Where adb-awake keeps its state on the device (the saved timeout, timer pid and restore script)
_ADB_AWAKE=/data/local/tmp/adb_awake

# Keep the screen on while on battery, e.g. over wireless debugging, where the developer option
# "Stay awake" does nothing because it only applies while charging.
# The timer runs on the device, so the original timeout comes back even if adb disconnects first.
#   adb-awake      awake for 30 minutes
#   adb-awake 90   awake for 90 minutes
#   adb-awake 0    awake until adb-sleep
function adb-awake() {
  local minutes=${1:-30}
  if [[ $minutes != <-> ]]; then
    echo "Usage: adb-awake [minutes]  (0 = until adb-sleep)"
    return 1
  fi

  adb shell sh -s $_ADB_AWAKE $(( minutes * 60 )) <<'EOF' || return
f=$1
secs=$2

# Script that puts the original timeout back, shared by the timer and adb-sleep
cat > $f.restore <<'RESTORE'
f=$1
if [ -f $f.timeout ]; then
  t=$(cat $f.timeout)
  if [ "$t" = null ]; then
    settings delete system screen_off_timeout > /dev/null
  else
    settings put system screen_off_timeout $t
  fi
fi
rm -f $f.timeout $f.pid
RESTORE

# Cancel the timer from an earlier adb-awake
[ -f $f.pid ] && kill $(cat $f.pid) 2> /dev/null
rm -f $f.pid

# Save the original timeout, unless an earlier adb-awake already replaced it
[ -f $f.timeout ] || settings get system screen_off_timeout > $f.timeout
settings put system screen_off_timeout 2147483647

if [ $secs -gt 0 ]; then
  nohup sh -c "sleep $secs; sh $f.restore $f" > /dev/null 2>&1 < /dev/null &
  echo $! > $f.pid
fi
EOF

  if (( minutes > 0 )); then
    echo "Screen stays on for $minutes minutes (adb-sleep to end early)"
  else
    echo "Screen stays on until adb-sleep"
  fi
}

# End adb-awake early: cancel its timer and put the original screen timeout back
function adb-sleep() {
  adb shell sh -s $_ADB_AWAKE <<'EOF' || return
f=$1
[ -f $f.pid ] && kill $(cat $f.pid) 2> /dev/null
[ -f $f.restore ] && sh $f.restore $f
EOF

  echo "Screen timeout restored to $(( $(adb shell settings get system screen_off_timeout) / 1000 ))s"
}
