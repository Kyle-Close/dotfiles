# Dotfiles Setup

This repository contains configuration files for various tools and environments. Follow these steps to set up your environment on a new system.

## Prerequisites

Should be able to just run the 'setup.sh' script to handle installing dependencies.

After running this once on Ubuntu there were a few hiccups.
- The symlinks didn't work. I think it's because the files aleady existed where I was trying to link to. So adding a step to rm that file would probably be best.


On **Ubuntu**, you can install these tools with:

```bash
sudo apt update
sudo apt install -y git stow curl neovim zsh tmux
---------------------------------------------------------------
### Symlinks
This can all be handled with 'stow'. With stow we just have to keep this repo in the same structure as if it was the root folder. For example, normally neovim looks for init.vim in ~/.config/nvim so in this repo we need to have the same structure which is ./config/nvim/init.vim.

On a new install we need to unlink and remove the symlink paths first before setting up the links. This is in case they already exist.
