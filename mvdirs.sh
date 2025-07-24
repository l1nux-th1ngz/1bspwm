#!/bin/bash

# Move directories
mv {bspwm,dmenu,dunst,gtk-2.0,gtk-3.0,polybar,qt5ct,qt6ct,rofi,sxhkd,geany} ~/.config/

# Set permissions
chmod -R 777 ~/.config/{bspwm,dmenu,dunst,polybar,rofi,sxhkd}

# Prompt for username
read -p "Enter your username: " username

# Change ownership
chown -R "$username:$username" ~/.config/{bspwm,dmenu,dunst,gtk-2.0,gtk-3.0,polybar,qt5ct,qt6ct,rofi,sxhkd,geany}

echo "Done"
