#!/bin/bash

sudo apt install fonts-noto-core fonts-noto-cjk fonts-hack-ttf -y
sudo apt install fontconfig fontconfig-config font-manager nemo-font-manager -y
sudo apt install fonts-recommended fonts-font-awesome fonts-terminus -y
sudo apt install fonts-liberation2 fonts-noto-color-emoji fonts-dejavu -y

cd ~/.fonts

fonts=("FiraCode" "JetBrainsMono" "Mononoki" "Terminus" "CommitMono" "Noto")

for font in "${fonts[@]}"; do
    wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/${font}.zip"
    unzip -n "${font}.zip"
    rm -f "${font}.zip"
done

fc-cache -fv
cd ~/

wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
mv PowerlineSymbols.otf ~/.local/share/fonts/
fc-cache -vf ~/.local/share/fonts/
mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts
