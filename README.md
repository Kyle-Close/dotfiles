# Dotfiles Setup

This repository contains configuration files for various tools and environments. Follow these steps to set up your environment on a new system.

## Prerequisites

You should be able to just run the 'setup.sh' script to handle installing dependencies. However, if it fails you need to make sure to manually install these:
- Git
- stow (for managing symlinks)
- curl
- Neovim
- Zsh
- Tmux

On **Ubuntu**, you can install these tools with:

```bash
sudo apt update
sudo apt install -y git stow curl neovim zsh tmux
