#!/bin/bash

# Make bin dir
mkdir -p "$HOME/.local/bin"

# Add to path
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
  echo "Added ~/.local/bin to PATH in ~/.bashrc"
fi

# Promt user
read -rp "Would you like to apply changes immediately? (y/n): " apply_now
if [[ "$apply_now" =~ ^[Yy]$ ]]; then
  source "$HOME/.bashrc"
else
  echo "Shell session needs to be restarted to apply changes."
fi


# Shared Local
mkdir -p "$HOME/.local/share/fonts"
mkdir -p "$HOME/.local/share/icons"
mkdir -p "$HOME/.local/share/themes"

chmod -R 755 "$HOME/.local/share/fonts"
chmod -R 755 "$HOME/.local/share/icons"
chmod -R 755 "$HOME/.local/share/themes"

# Home directories
mkdir -p "$HOME/.fonts"
mkdir -p "$HOME/.icons"
mkdir -p "$HOME/.themes"

chmod -R 755 "$HOME/.fonts"
chmod -R 755 "$HOME/.icons"
chmod -R 755 "$HOME/.themes"

# Dot Config
mkdir -p "$HOME/.config/fontconfig"

# Custom Dirs
mkdir -p "$HOME/Pictures/ScreenShots"
mkdir -p "$HOME/Videos/ScreenRecs"
mkdir -p "$HOME/Documents/System-Backup"
