#!/bin/bash

# Update
sudo apt update

# Install
sudo apt install -y netselect dpkg-dev fakeroot gcc gpgv debian-keyring
sudo apt install -y netselect-apt gnupg sq sqop pgpainless libalgorithm-merge-perl

# Prompt user
read -p "Would you like to change your Debian mirror? (Y/y for Yes): " choice

if [[ "$choice" =~ ^[Yy]$ ]]; then
    chmod +x sourcechanger.sh
    ./sourcechanger.sh
else
    echo "Netselect installation is complete."
fi
