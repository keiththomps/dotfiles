#!/usr/bin/env bash

dotfiles=(
  ".agignore"
  ".bash_profile"
  ".bashrc"
  "bin"
  ".gemrc"
  # ".gitconfig"
  ".githelpers"
  ".inputrc"
  ".irbrc"
  ".pryrc"
  ".shell_defaults"
  ".tmux.conf"
  "init.vim|.config/nvim"
  ".zprofile"
  ".zshrc"
)

# Link all dotfiles
for file in ${dotfiles[@]}; do
  if [[ $file == *"|"* ]]; then
    localFile=`echo $file | cut -d "|" -f1`
    destinationDir=$HOME/`echo $file | cut -d "|" -f2`
    if [[ ! -d $destinationDir ]]; then
      echo "Creating ${destinationDir}"
      mkdir -p $destinationDir
    fi
  else
    destinationDir=$HOME
    localFile=$file
  fi

  localPath=$PWD/$localFile
  linkedFile="${destinationDir}/${localFile}"

  if [[ -L $linkedFile ]]; then
    echo "Unlinking $linkedFile"
    rm -rf $linkedFile
  elif [[ -f $linkedFile ]]; then
    echo "Removing existing $linkedFile"
    rm -rf $linkedFile
  fi

  echo "Linking $linkedFile"
  ln -s $localPath $linkedFile
done

# Install Dependencies

if [ $SPIN ]; then
  sudo apt-get remove -y neovim
  sudo apt-get install -y \
    python3-pip \
    ripgrep \
    tree \
    fzf \
    tmux

  # Fetch App Image for NeoVim
  NVIM_VERSION="v0.6.1"
  mkdir -p $HOME/dotfiles/tmp
  cd $HOME/dotfiles/tmp
  rm -rf nvim.appimage squashfs-root
  wget "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim.appimage"
  chmod u+x nvim.appimage
  ./nvim.appimage --appimage-extract
  sudo rm -f /usr/local/bin/nvim
  sudo ln -s $PWD/squashfs-root/usr/bin/nvim /usr/local/bin/nvim

  python3.9 -m pip install neovim
  sudo gem install neovim
  npm -g install neovim

  if [[ ! -f /usr/local/bin/tree-sitter ]]; then
    # Install Tree-Sitter
    TS_VERSION="v0.20.1"
    wget "https://github.com/tree-sitter/tree-sitter/releases/download/${TS_VERSION}/tree-sitter-linux-x64.gz"
    gunzip tree-sitter-linux-x64.gz
    chmod u+x tree-sitter-linux-x64
    sudo mv tree-sitter-linux-x64 /usr/local/bin/tree-sitter
  fi

  cd $HOME/dotfiles
  rm -rf $HOME/dotfiles/tmp
fi

# Add darwin steps here

if [[ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]]; then
  # Install Plug for NeoVim Plugins
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if [[ -n $(command -v nvim) ]]; then
  # Install and Upgrade NeoVim Plugins
  nvim +silent +PlugUpgrade +PlugInstall +PlugUpdate +PlugClean +q +q
fi

# Install global gems for NeoVim
sudo gem install sorbet
