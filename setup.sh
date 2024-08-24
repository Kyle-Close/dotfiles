#!/bin/bash

# Update and upgrade the system (Ubuntu)
if [ "$(uname)" == "Linux" ]; then
  sudo apt update && sudo apt upgrade -y
  # Install essential software for Ubuntu
  sudo apt install -y git stow curl neovim zsh tmux
fi

# Install Homebrew if on macOS
if [ "$(uname)" == "Darwin" ]; then
  # Check if Homebrew is installed, install if not
  which -s brew
  if [[ $? != 0 ]] ; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Update Homebrew and install essential software for macOS
  brew update
  brew install git stow curl neovim zsh tmux
fi

# Clone your dotfiles repository
if [ ! -d "$HOME/dotfiles" ]; then
  git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
fi

# Change to the dotfiles directory
cd ~/dotfiles

# Use stow to set up symlinks
stow .

# Install Vim Plug if not already installed
if [ ! -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]; then
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Install Neovim plugins
nvim +'PlugInstall --sync' +qa

# Set Zsh as the default shell
chsh -s $(which zsh)

# Optionally, install Oh My Zsh (if you use it)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Optionally, install any other custom tools or scripts you need
# e.g., install a custom prompt, fonts, etc.

# Final message
echo "Setup complete! Please restart your terminal or log out and back in to apply changes."
