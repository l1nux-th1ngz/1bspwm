#!/bin/bash

# Update
sudo apt update

# Build Tools
sudo apt install build-essential make gcc cmake bison meson ninja-build curl pkg-config wget git  gnupg xauth -y
sudo apt install zip unzip autoconf autoconf-archive automake autotools-dev gettext autorandr bash-completions -y
sudo apt install libtool-bin libtool pkg-config clangd intltool intltool-debian systemd-sysv sysvinit-core -y
sudo apt install libnss-systemd libpam-systemd -y

# Display server
sudo apt install xinit  xorg xorg-dev x11-utils x11-xkb-utils x11-xserver-utils  -y
sudo apt install xserver-xorg-core xserver-xorg-video-intel xserver-xorg-input-libinput -y

# Dependcies
sudo apt install xbindkeys xbacklight xbindkeys xvkbd xinput  libx11-dev libxft-dev libxinerama-dev -y
sudo apt install xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev -y
sudo apt install libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev  -y

# Processor
sudo apt install intel-microcode -y

# Bspwm
sudo apt install init bspwm sxhkd suckless-tools xdo xdotool inxi -y
sudo apt install xautomation xsettingsd wmctrl rxvt-unicode intltool-debian -y
sudo apt install dunst feh lxappearance mtools samba-client cifs-utils terminator -y
sudo apt install nemo dialog feh lxappearance network-manager-gnome mirage -y
sudo apt install dunst avahi-daemon intltool acpi acpid jq -y
sudo apt install trash-cli brightnessctl light geany-plugins bluefish -y
sudo apt install silversearcher-ag fd-find vs ripgrep gvfs-backends -y
sudo apt install rofi-dev polybar xq yq -y

# XFCE Power no recommends
sudo apt install xfce4-power-manager -o APT::Install-Recommends=false -y

sudo apt install xdg-user-dir-gtk -y
sleep 3
# Setup User Directories
xdg-user-dirs-update
sleep 3
xdg-user-dirs-gtk-update
sleep 3

# Wait for everything to finsish
wait
echo "Please continue to the next script"
