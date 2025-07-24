#!/bin/bash

# Update
sudo apt update

# Install
sudo apt install bluetooth bluez-tools blueman libspa-0.2-bluetooth gstreamer1.0-gl gstreamer1.0-x gstreamer1.0-plugins-bad rfkill -y

# Enable
sudo systemctl enable bluetooth

echo "Done"
