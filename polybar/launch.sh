#!/usr/bin/env sh

# Kill running polybar instances
killall -q polybar

# Wait for processes to shut down
while pgrep -u "$UID" -x polybar >/dev/null; do
  sleep 1
done

# Config file path
CONFIG_PATH="$HOME/.config/polybar/config.ini"

# Launch
polybar -c "$CONFIG_PATH" work &
polybar -c "$CONFIG_PATH" bar &
polybar -c "$CONFIG_PATH" menu &
polybar -c "$CONFIG_PATH" main &
