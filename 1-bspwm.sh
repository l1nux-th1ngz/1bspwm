#!/bin/bash

# Update
sudo apt update

# Build Tools
sudo apt install build-essential make gcc cmake bison meson ninja-build curl pkg-config wget git  gnupg xauth -y
sudo apt install zip unzip autoconf autoconf-archive automake autotools-dev gettext autorandr bash-completions -y
sudo apt install libtool-bin libtool pkg-config clangd intltool intltool-debian systemd-sysv sysvinit-core -y
sudo apt install libnss-systemd libpam-systemd -y

# Update
sudo apt update

touch ~/.Xauthority

# Display server
sudo apt install xinit  xorg xorg-dev x11-utils x11-xkb-utils x11-xserver-utils  -y
sudo apt install xserver-xorg-core xserver-xorg-video-intel xserver-xorg-input-libinput -y

# Update
sudo apt update

cp /etc/X11/xinit/xinitrc ~/.xinitrc
cp /etc/profile  ~/.profile

# Dependcies
sudo apt install xbindkeys xbacklight xbindkeys xvkbd xinput  libx11-dev libxft-dev libxinerama-dev -y
sudo apt install xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev -y
sudo apt install libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev  -y

# Update
sudo apt update

# Processor
sudo apt install intel-microcode -y

# Bspwm
sudo apt install init bspwm sxhkd suckless-tools xdo xdotool inxi -y
sudo apt install xautomation xsettingsd wmctrl rxvt-unicode intltool-debian -y
sudo apt install dunst feh lxappearance mtools samba-client cifs-utils terminator -y
sudo apt install nemo dialog feh lxappearance network-manager-gnome mirage -y
sudo apt install dunst avahi-daemon intltool acpi acpid xdg-user-dir-gtk jq -y
sudo apt install trash-cli brightnessctl light geany-plugins bluefish -y
sudo apt install silversearcher-ag fd-find vs ripgrep gvfs-backends -y
sudo apt install rofi-dev polybar xq yq -y

# Update
sudo apt update

# XFCE Power no recommends
sudo apt install xfce4-power-manager -o APT::Install-Recommends=false -y

# Update
sudo apt update

# Enable Power Manager
xfce4-power-manager &

 # Enable Avahi
sudo systemctl start avahi-daemon
sudo systemctl enable avahi-daemon

 # Setup directories
xdg-user-dirs-update

echo "Please continue to the next script"
