#!/bin/bash

# Ensure the script exits on any command that fails
set -e

# Update package lists and install necessary packages

# Check if running on macOS or Ubuntu
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Setting up on macOS..."

    # Install Homebrew if not already installed
    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install GNU Stow and other necessary packages
    brew install stow curl wget git

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Setting up on Ubuntu..."

    sudo apt update
    sudo apt install -y stow curl wget git
fi

# Run stow to create symlinks
cd ~/dotfiles
stow .

# Check for and install Vim-Plug (or other plugin managers) for Neovim
if [ ! -f "~/.local/share/nvim/site/autoload/plug.vim" ]; then
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Install Neovim plugins
nvim +PlugInstall +qall

echo "Setup completed successfully!"
