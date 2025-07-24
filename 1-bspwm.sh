#!/bin/bash

# Update
sudo apt update

# Build Tools
sudo apt install -y \
  build-essential make gcc cmake bison meson ninja-build curl pkg-config wget git gnupg xauth \
  zip unzip autoconf autoconf-archive automake autotools-dev gettext autorandr bash-completion \
  libtool-bin libtool clangd intltool intltool-debian systemd-sysv sysvinit-core \
  libnss-systemd libpam-systemd

# Display Server
sudo apt install -y \
  xinit xorg xorg-dev x11-utils x11-xkb-utils x11-xserver-utils \
  xserver-xorg-core xserver-xorg-video-intel xserver-xorg-input-libinput

# X Authority + Profile
touch ~/.Xauthority
cp /etc/X11/xinit/xinitrc ~/.xinitrc
cp /etc/profile ~/.profile

# Take Ownership
sudo chown "$USER:$USER" ~/.profile ~/.xinitrc ~/.Xauthority

# Dependencies
sudo apt install -y \
  xbindkeys xbacklight xvkbd xinput libx11-dev libxft-dev libxinerama-dev \
  libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev \
  libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev

# ⚙ Processor
sudo apt install -y intel-microcode

# Bspwm + Utilities
sudo apt install -y \
  init bspwm sxhkd suckless-tools xdo xdotool inxi xautomation xsettingsd wmctrl \
  rxvt-unicode dunst feh lxappearance mtools samba-client cifs-utils terminator \
  nemo dialog network-manager-gnome mirage avahi-daemon acpi acpid xdg-user-dir-gtk jq \
  trash-cli brightnessctl light geany-plugins bluefish silversearcher-ag fd-find vs ripgrep \
  gvfs-backends rofi-dev polybar xq yq qt5ct qt6ct

# Power Manager
sudo apt install -y xfce4-power-manager -o APT::Install-Recommends=false

# Launch Power Manager
# xfce4-power-manager &

# Setup User Directories
xdg-user-dirs-update

echo "Setup complete. Please continue to the next script."

