#!/bin/bash

### Helper Function ###
run() {
  if ! pgrep -x "$1" > /dev/null; then
    "$@" &
  fi
}

### Monitor Setup (Optional) ###
# Uncomment and customize if needed
# xrandr --output HDMI1 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
#        --output HDMI2 --mode 1920x1080 --pos 1920x0 --rotate normal --output VIRTUAL1 --off
# autorandr horizontal

### Set display from arandr saved script ###
# sh ~/.screenlayout/monitor.sh &

### System Tray Utilities ###
run nm-applet
run volumeicon

### Enable Numlock ###
numlockx on &

### Notification Daemon ###
killall dunst 2>/dev/null
run dunst

### Polybar ###
"$HOME/.config/polybar/launch.sh"

### X Resources ###
xrdb merge "$HOME/.Xresources"

### SXHKD ###
run sxhkd -c "$HOME/.config/sxhkd/sxhkdrc"

### Wallpaper ###
WALLPAPER_DIR="$HOME/.config/wallpapers"
if [ -d "$WALLPAPER_DIR" ]; then
  RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
  [ -n "$RANDOM_WALLPAPER" ] && feh --bg-scale "$RANDOM_WALLPAPER" &
fi

### Compositor ###
run picom --config "$HOME/.config/picom/picom.conf"

### Brightness ###
"$HOME/.config/scripts/brightness-startup.sh" &> /dev/null &

### Power Management ###
run xfce-power-manager &

### PolicyKit Agent ###
run polkit-gnome-authentication-agent-1

### Wallpaper Changer ###
"$HOME/.config/bspwm/scripts/wallpc.sh"

### Low battery notifier ###
"$HOME/.config/bspwm/scripts/low_bat_notifier.sh"


###  DEX Optional Autostart Apps ###
# dex "$HOME/.config/autostart/app.desktop"
