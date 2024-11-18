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
  ".shell_defaults"
  "shell_gpt|.config"
  ".tmux.conf"
  ".tuple"
  "nvim|.config"
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
    all_dotfiles=("${dotfiles[@]}" "${shopify_config[@]}");
  else
    all_dotfiles=("${dotfiles[@]}" "${personal_config[@]}");
  fi
else
  all_dotfiles=("${dotfiles[@]}");
fi

# Link all dotfiles
for file in ${all_dotfiles[@]}; do
  if [[ $file == *"|"* ]]; then
    filePortion=`echo $file | cut -d "|" -f1`
    localFile=`local_file_name $filePortion`
    destinationFile=`desired_file_name $filePortion`
    destinationDir=$HOME/`echo $file | cut -d "|" -f2`
    linkedFile="${destinationDir}/${destinationFile}"
    if [ -L $linkedFile ]; then
      echo "Unlinking $linkedFile"
      rm -rf $linkedFile
    elif [ -f $linkedFile ]; then
      echo "Removing existing $linkedFile"
      rm -rf $linkedFile
    fi

    if [ ! -d $destinationDir ]; then
      echo "Creating ${destinationDir}"
      mkdir -p $destinationDir
    fi
  else
    destinationDir=$HOME
    localFile=`local_file_name $file`
    destinationFile=`desired_file_name $file`
    linkedFile="${destinationDir}/${destinationFile}"
    if [ -L $linkedFile ]; then
      echo "Unlinking $linkedFile"
      rm -rf $linkedFile
    elif [ -f $linkedFile ]; then
      echo "Removing existing $linkedFile"
      rm -rf $linkedFile
    fi
  fi

  localPath=$PWD/$localFile

  echo "Linking $linkedFile"
  ln -s $localPath $linkedFile
done

if [ $LINK_ONLY ]; then
  exit 0
fi

echo "Installing with Brew"

# Install homebrew
if [[ -z $(command -v brew) ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install packages via homebrew
brew bundle

# Add darwin steps here
if [[ $OSTYPE == 'darwin'* ]]; then
  echo "Setting macOS defaults"
  ./macos_defaults.sh
fi

mkdir -p $HOME/.1password

# Cursor setup

if command -v cursor >/dev/null 2>&1; then
  # Determine OS and set Cursor path
  if [[ "$OSTYPE" == "darwin"* ]]; then
    CURSOR_PATH="$HOME/Library/Application Support/Cursor/User"
    CURSOR_EXTENSIONS_PATH="$HOME/.cursor/extensions"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    CURSOR_PATH="$HOME/.config/Cursor/User"
    CURSOR_EXTENSIONS_PATH="$HOME/.cursor/extensions"
  fi

  # Install Cursor settings
  ln -s $PWD/cursor/settings.json $CURSOR_PATH/settings.json
  ln -s $PWD/cursor/keybindings.json $CURSOR_PATH/keybindings.json

  # Install Cursor extensions
  while read -r extension; do
    cursor --install-extension $extension
  done < "$PWD/cursor/extensions.txt"

  # Install custom Cursor extensions
  for extension_dir in $PWD/cursor/extensions/*; do
    if [ -d "$extension_dir" ]; then
      extension_name=$(basename "$extension_dir")
      mkdir -p "$CURSOR_EXTENSIONS_PATH"
      rm -rf "$CURSOR_EXTENSIONS_PATH/$extension_name"
      ln -s "$extension_dir" "$CURSOR_EXTENSIONS_PATH/$extension_name"
    fi
  done
fi
