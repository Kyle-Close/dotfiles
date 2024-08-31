#!/usr/bin/env bash

DOTFILES="$(pwd)"

title() {
  echo -e "\n${COLOR_PURPLE}$1${COLOR_NONE}"
  echo -e "${COLOR_GRAY}==============================${COLOR_NONE}\n"
}

error() {
  echo -e "${COLOR_RED}Error: ${COLOR_NONE}$1"
  exit 1
}

warning() {
  echo -e "${COLOR_YELLOW}Warning: ${COLOR_NONE}$1"
}

info() {
  echo -e "${COLOR_BLUE}Info: ${COLOR_NONE}$1"
}

success() {
  echo -e "${COLOR_GREEN}$1${COLOR_NONE}"
}

install_homebrew() {
  title "Homebrew"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v brew &> /dev/null; then
      info "Homebrew not found. Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
      info "Homebrew is already installed."
    fi
  else
    info "Not running on macOS. Skipping Homebrew installation."
  fi
}

setup_git() {
  title "Setting up Git"

  # Retrieve current Git configuration
  defaultName=$(git config --global user.name)
  defaultEmail=$(git config --global user.email)
  defaultGithub=$(git config --global github.user)

  # Check if the user already has these configurations set
  if [[ -n "$defaultName" && -n "$defaultEmail" && -n "$defaultGithub" ]]; then
    echo "Git is already configured with the following settings:"
    echo "Name: $defaultName"
    echo "Email: $defaultEmail"
    echo "GitHub Username: $defaultGithub"
    read -rp "Do you want to update these settings? (y/n) " update
    if [[ ! $update =~ ^([Yy])$ ]]; then
      echo "Skipping Git setup."
      return
    fi
  fi

  # Prompt user for new Git configuration
  read -rp "Name [$defaultName] " name
  read -rp "Email [$defaultEmail] " email
  read -rp "GitHub username [$defaultGithub] " github

  # Apply Git configuration
  git config --global user.name "${name:-$defaultName}"
  git config --global user.email "${email:-$defaultEmail}"
  git config --global github.user "${github:-$defaultGithub}"

  # Configure credential helper
  if [[ "$(uname)" == "Darwin" ]]; then
    git config --global credential.helper "osxkeychain"
  else
    read -rn 1 -p "Save user and password to an unencrypted file to avoid writing? [y/N] " save
    if [[ $save =~ ^([Yy])$ ]]; then
      git config --global credential.helper "store"
    else
      git config --global credential.helper "cache --timeout 3600"
    fi
  fi
}

install_essentials() {
  title "Installing essential software"

  # Check if the OS is macOS or Ubuntu
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    brew update
    brew install git stow curl neovim zsh tmux
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Ubuntu (or other Debian-based distributions)
    sudo apt-get update
    sudo apt-get install -y git stow curl neovim zsh tmux
  else
    echo "Unsupported OS: $OSTYPE"
    exit 1
  fi

  # Install Vim Plug for Neovim
  if [ ! -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]; then
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi
}

cleanup_symlinks() {
  echo "Removing existing symlinks..."
  stow -D .
}

setup_symlinks(){
  echo "Setting up symlinks with stow..."
  stow .
}

handle_symlinks(){
  title "Setting up symlinks"
  cleanup_symlinks
  setup_symlinks
}

install_essentials
setup_git
install_homebrew
handle_symlinks

success "Done."
