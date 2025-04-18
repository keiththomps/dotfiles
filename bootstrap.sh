#!/usr/bin/env bash

dotfiles=(
  ".agignore"
  ".bash_profile"
  ".bashrc"
  ".bin"
  ".gemrc"
  ".githelpers"
  ".gitmessage"
  ".inputrc"
  ".irbrc"
  ".pryrc"
  "prompts@.prompts"
  "claude@.claude"
  ".shell_defaults"
  "shell_gpt|.config"
  ".tmux.conf"
  ".tuple"
  "nvim|.config"
  "ghostty|.config"
  ".zprofile"
  ".zshrc"
)

shopify_config=(
  "gitconfig_shopify@.gitconfig"
)

personal_config=(
  "gitconfig_personal@.gitconfig"
)

function local_file_name() {
  IFS='@' read -ra ADDR <<< "$1"
  if [ ${#ADDR[@]} -gt 1 ]; then
    echo "${ADDR[0]}"
  else
    echo "$1"
  fi
}

function desired_file_name() {
  IFS='@' read -ra ADDR <<< "$1"
  if [ ${#ADDR[@]} -gt 1 ]; then
    echo "${ADDR[1]}"
  else
    echo "$1"
  fi
}

# Check for zero length $SPIN
if [ -z "${SPIN}" ]; then
  if [ "$SHOPIFY" == "true" ]; then
    all_dotfiles=("${dotfiles[@]}" "${shopify_config[@]}")
  else
    all_dotfiles=("${dotfiles[@]}" "${personal_config[@]}")
  fi
else
  all_dotfiles=("${dotfiles[@]}")
fi

# Link all dotfiles
for file in "${all_dotfiles[@]}"; do
  if [[ $file == *"|"* ]]; then
    filePortion=$(echo "$file" | cut -d "|" -f1)
    localFile=$(local_file_name "$filePortion")
    destinationFile=$(desired_file_name "$filePortion")
    destinationDir=$HOME/$(echo "$file" | cut -d "|" -f2)
    linkedFile="${destinationDir}/${destinationFile}"
    if [ -L "$linkedFile" ]; then
      echo "Unlinking $linkedFile"
      rm -rf "$linkedFile"
    elif [ -f "$linkedFile" ]; then
      echo "Removing existing $linkedFile"
      rm -rf "$linkedFile"
    fi

    if [ ! -d "$destinationDir" ]; then
      echo "Creating ${destinationDir}"
      mkdir -p "$destinationDir"
    fi
  else
    destinationDir=$HOME
    localFile=$(local_file_name "$file")
    destinationFile=$(desired_file_name "$file")
    linkedFile="${destinationDir}/${destinationFile}"
    if [ -L "$linkedFile" ]; then
      echo "Unlinking $linkedFile"
      rm -rf "$linkedFile"
    elif [ -f "$linkedFile" ]; then
      echo "Removing existing $linkedFile"
      rm -rf "$linkedFile"
    fi
  fi

  localPath=$PWD/$localFile

  echo "Linking $linkedFile"
  ln -s "$localPath" "$linkedFile"
done

if [ "$LINK_ONLY" ]; then
  exit 0
fi

# Package installation block: support for Homebrew or dnf
if command -v brew >/dev/null 2>&1; then
  echo "Installing with Homebrew"
  # Install Homebrew if not present (redundant check, but for safety)
  if [[ -z $(command -v brew) ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  brew bundle
elif command -v dnf >/dev/null 2>&1; then
  echo "Installing with dnf"
  # Define package list for dnf (adjust these packages as needed to match your Brewfile)
  dnf_packages=(
    git
    tmux
    neovim
    curl
    wget
    tree
    jq
    nodejs
    ripgrep
    ruby-install
    chruby
  )
  sudo dnf check-update
  sudo dnf copr enable duritong/chruby
  sudo dnf install -y "${dnf_packages[@]}"
else
  echo "No supported package manager found (Homebrew or dnf). Please install one."
fi

# Add darwin steps here
if [[ $OSTYPE == 'darwin'* ]]; then
  echo "Setting macOS defaults"
  ./macos_defaults.sh
fi

mkdir -p "$HOME/.1password"
