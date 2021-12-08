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
    python3-neovim \
    ruby-neovim \
    ripgrep \
    tree \
    tmux

  # Fetch App Image for NeoVim
  NVIM_VERSION="v0.6.0"
  mkdir -p $HOME/dotfiles/tmp
  cd $HOME/dotfiles/tmp
  rm -rf nvim.appimage squashfs-root
  wget "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim.appimage"
  chmod u+x nvim.appimage
  ./nvim.appimage --appimage-extract
  sudo rm -f /usr/local/bin/nvim
  sudo ln -s $PWD/squashfs-root/usr/bin/nvim /usr/local/bin/nvim
fi


# Set up NeoVim pluggins
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Updating NeoVim Plugins"
nvim +PlugUpgrade +PlugInstall +PlugUpdate +PlugClean +q +q
