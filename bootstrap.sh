#!/usr/bin/env bash

dotfiles=(
  ".agignore"
  ".bash_profile"
  ".bashrc"
  ".bin"
  ".gemrc"
  ".githelpers"
  ".inputrc"
  ".irbrc"
  ".pryrc"
  ".shell_defaults"
  ".tmux.conf"
  "nvim|.config"
  ".zprofile"
  ".zshrc"
)

spin_excluded=(
  ".gitconfig"
)

# Check for zero length $SPIN
if [[ -z "${SPIN}" ]]; then
  all_dotfiles=("${dotfiles[@]}" "${spin_excluded[@]}");
else
  all_dotfiles=("${dotfiles[@]}");
fi

# Link all dotfiles
for file in ${all_dotfiles[@]}; do
  if [[ $file == *"|"* ]]; then
    localFile=`echo $file | cut -d "|" -f1`
    destinationDir=$HOME/`echo $file | cut -d "|" -f2`
    linkedFile="${destinationDir}/${localFile}"
    if [[ -L $linkedFile ]]; then
      echo "Unlinking $linkedFile"
      rm -rf $linkedFile
    elif [[ -f $linkedFile ]]; then
      echo "Removing existing $linkedFile"
      rm -rf $linkedFile
    fi

    if [[ ! -d $destinationDir ]]; then
      echo "Creating ${destinationDir}"
      mkdir -p $destinationDir
    fi
  else
    destinationDir=$HOME
    localFile=$file
    linkedFile="${destinationDir}/${localFile}"
    if [[ -L $linkedFile ]]; then
      echo "Unlinking $linkedFile"
      rm -rf $linkedFile
    elif [[ -f $linkedFile ]]; then
      echo "Removing existing $linkedFile"
      rm -rf $linkedFile
    fi
  fi

  localPath=$PWD/$localFile

  echo "Linking $linkedFile"
  ln -s $localPath $linkedFile
done

# Install Dependencies in Spin

if [ $SPIN ]; then
  git config --global commit.gpgsign true

  sudo apt-get remove -y neovim
  sudo apt-get install -y \
    python3-pip \
    ripgrep \
    tree \
    fzf \
    tmux

  sudo apt autoremove -yqq

  # Fetch App Image for NeoVim
  NVIM_VERSION="v0.8.3"
  mkdir -p $HOME/dotfiles/tmp
  cd /usr/local/src
  sudo rm -rf nvim.appimage squashfs-root
  sudo wget "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim.appimage"
  sudo chmod u+x nvim.appimage
  sudo ./nvim.appimage --appimage-extract
  sudo rm -f /usr/local/bin/nvim
  sudo ln -s $PWD/squashfs-root/usr/bin/nvim /usr/local/bin/nvim

  python3.9 -m pip install neovim
  sudo gem install neovim
  npm -g install neovim

  cd $HOME/dotfiles
  rm -rf $HOME/dotfiles/tmp
fi

# Add darwin steps here
if [[ $OSTYPE == 'darwin'* ]]; then
  echo "Installing MacOS specifics"

  # Install homebrew
  if [[ -n $(command -v brew) ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    brew update && brew upgrade
  fi

  # Install packages via homebrew
  /usr/local/bin/brew bundle
fi

# if [[ -n $(command -v nvim) ]]; then
#   # Install Packer and Plugins
#   nvim --headless -c 'autocmd User PackerComplete quitall' -c 'Mason' -c 'PackerSync'
# fi

# Install global gems for NeoVim
sudo gem install sorbet
