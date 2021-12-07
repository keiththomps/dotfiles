#!/usr/bin/env bash

dotfiles=(
  ".agignore"
  ".bash_profile"
  ".bashrc"
  "bin"
  ".gemrc"
  ".gitconfig"
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
    rm $linkedFile
  elif [[ -f $lnkedFile ]]; then
    echo "Removing existing $linkedFile"
    rm -r $linkedFile
  fi

  echo "Linking $linkedFile"
  ln -s $localPath $linkedFile
done

# Install Dependencies

if [ $SPIN ]; then
  sudo apt-get install -y \
    neovim \
    python-neovim \
    python3-neovim \
    ruby-neovim \
    ripgrep \
    tree \
    tmux \
    the_silver_searcher \
fi


# Set up NeoVim pluggins
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Updating NeoVim Plugins"
nvim +PlugUpgrade +PlugInstall +PlugUpdate +PlugClean +q +q

