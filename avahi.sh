#!/bin/bash

# Install
sudo apt install avahi-daemon -y

# Create user and a group for avahi
addgroup --system avahi
adduser --system --no-create-home --ingroup avahi avahi

# Reload D-Bus
systemctl reload dbus


# Start and enable Avahi Daemon
sudo systemctl start avahi-daemon
sudo systemctl enable avahi-daemon

echo "Done"
