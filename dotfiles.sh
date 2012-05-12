#!/bin/bash
dir=$(pwd)
update_bundles() {
  ruby .vim/update_bundles.rb
}

create_links() {
  ln -s ${dir}/.bashrc ~/.bashrc
  ln -s ${dir}/.bash_profile ~/.bash_profile
  ln -s ${dir}/.gitconfig ~/.gitconfig
  ln -s ${dir}/.githelpers ~/.githelpers
  ln -s ${dir}/.profile ~/.profile
  ln -s ${dir}/.tmux.conf ~/.tmux.conf
  ln -s ${dir}/.vim ~/.vim
  ln -s ${dir}/.vimrc ~/.vimrc
  ln -s ${dir}/.jshintrc ~/.jshintrc
}

destroy_links() {
  rm -f ~/.bashrc
  rm -f ~/.bash_profile
  rm -f ~/.gitconfig
  rm -f ~/.githelpers
  rm -f ~/.profile
  rm -f ~/.tmux.conf
  rm -rf ~/.vim
  rm -f ~/.vimrc
  rm -f ~/.jshintrc
}
