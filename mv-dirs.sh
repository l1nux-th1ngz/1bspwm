#!/bin/bash

# Move directories
mv {bspwm,dmenu,dunst,gtk-2.0,gtk-3.0,polybar,qt5ct,qt6ct,rofi,sxhkd,geany} ~/.config/

# Set permissions
chmod -R 777 ~/.config/{bspwm,dmenu,dunst,polybar,rofi,sxhkd}

echo "Done"
