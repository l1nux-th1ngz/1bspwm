#!/bin/bash

# Update package list
sudo apt update

# Install 
sudo apt install -y zsh git wget

# Run zsh 
zsh


################################
if [ "$input" == "2" ]; then
    echo "Proceeding with setup..."

    # Install Oh My Zsh if not already installed
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing Oh My Zsh..."
        sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
    fi

    # Define custom plugin/theme directory
    ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

    # Clone plugins if not exist
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
    fi

    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
    fi

    # Clone Powerlevel10k theme if not exist
    if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k
    fi

    # Add to  ~/.zshrc
    cat > "$HOME/.zshrc" <<EOF
# Custom Zsh configuration

# Path to oh-my-zsh
export ZSH="\$HOME/.oh-my-zsh"

# Set theme to Powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Source oh-my-zsh
source \$ZSH/oh-my-zsh.sh
EOF

    echo "Your ~/.zshrc has been updated."

    echo "Setup is complete. Please restart your terminal or run:"
    echo "  source ~/.zshrc"
fi
