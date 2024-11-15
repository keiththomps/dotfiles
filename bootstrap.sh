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

if [ ! -z "$WSL_DISTRO_NAME" ]; then
  personal_config=(
    "gitconfig_wsl@.gitconfig"
    ".agent-bridge.sh"
  )
fi

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

# Install Dependencies in Spin

if [[ $OSTYPE == 'linux'* ]]; then
  echo "Installing Linux specifics"
  if [ $SPIN ]; then
    git config --global commit.gpgsign true
    git config --global include.path "~/dotfiles/gitconfig_common"
  fi

  sudo apt-get install -y \
    python3-pip \
    ripgrep \
    tree \
    fzf \
    socat \
    tmux

  sudo apt autoremove -yqq

  if [[ -n $(command -v python3) ]]; then
    python3 -m pip install neovim shell-gpt
  fi

  if [[ -n $(command -v gem) ]]; then
    sudo gem install neovim
  fi

  if [[ -n $(command -v gem) ]]; then
    npm -g install neovim
  fi

  cd $HOME/dotfiles
  rm -rf $HOME/dotfiles/tmp

  if [ -f /etc/spin/secrets/copilot-credentials ]; then
    mkdir -p "${HOME}/.config/github-copilot"
    cp /etc/spin/secrets/copilot-credentials "${HOME}/.config/github-copilot/hosts.json"
  fi

  sudo mkdir -p /opt/ejson/keys

  for ejson_file in /etc/spin/secrets/ejson-*; do
    sudo ln -s "$ejson_file" "/opt/ejson/keys/$(basename ${ejson_file#*/ejson-})" > /dev/null 2>&1 || true
  done

  # Correct shell_gpt config for spin
  sed -i "s/\/Users\/keith/\/home\/spin/g" /home/spin/.config/shell_gpt/.sgptrc
fi

# Add darwin steps here
if [[ $OSTYPE == 'darwin'* ]]; then
  echo "Installing MacOS specifics"

  # Install homebrew
  if [[ -z $(command -v brew) ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Install packages via homebrew
  brew bundle

  echo "Setting macOS defaults"
  ./macos_defaults.sh
fi

# Install global gems for NeoVim
if [ $SPIN ]; then
  sudo gem install sorbet
fi

mkdir -p $HOME/.1password

# Determine OS and set Cursor path
if [[ "$OSTYPE" == "darwin"* ]]; then
  CURSOR_PATH="$HOME/Library/Application Support/Cursor/User"
  CURSOR_EXTENSIONS_PATH="$HOME/.cursor/extensions"
elif [[ "$WSL_DISTRO_NAME" ]]; then
  CURSOR_PATH="/mnt/c/Users/keith/AppData/Roaming/Cursor/User"
  CURSOR_EXTENSIONS_PATH="/mnt/c/Users/keith/.cursor/extensions"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  CURSOR_PATH="$HOME/.config/Cursor/User"
  CURSOR_EXTENSIONS_PATH="$HOME/.cursor/extensions"
else
  CURSOR_PATH="/mnt/c/Users/keith/AppData/Roaming/Cursor/User"
  CURSOR_EXTENSIONS_PATH="/mnt/c/Users/keith/.cursor/extensions"
fi

# Install Cursor settings
if [[ "$WSL_DISTRO_NAME" ]]; then
  # Copy settings and keybindings to Cursor path instead of symlinking
  cp $PWD/cursor/settings.json $CURSOR_PATH/settings.json
  cp $PWD/cursor/keybindings.json $CURSOR_PATH/keybindings.json
else
  ln -s $PWD/cursor/settings.json $CURSOR_PATH/settings.json
  ln -s $PWD/cursor/keybindings.json $CURSOR_PATH/keybindings.json
fi

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
    if [[ "$WSL_DISTRO_NAME" ]]; then
      cp -r "$extension_dir" "$CURSOR_EXTENSIONS_PATH/$extension_name"
    else
      ln -s "$extension_dir" "$CURSOR_EXTENSIONS_PATH/$extension_name"
    fi
  fi
done
