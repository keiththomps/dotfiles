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
  ln -s ${dir}/.gitignore_global ~/.gitignore_global
  ln -s ${dir}/.jshintrc ~/.jshintrc
  ln -s ${dir}/.profile ~/.profile
  ln -s ${dir}/.tmux.conf ~/.tmux.conf
  ln -s ${dir}/.vim ~/.vim
  rm -f ${dir}/.vim/.vim
  ln -s ${dir}/.vimrc ~/.vimrc
  ln -s ${dir}/.zlogin ~/.zlogin
  ln -s ${dir}/.zshrc ~/.zshrc
  ln -s ${dir}/bin ~/bin
}

destroy_links() {
  rm -f ~/.bashrc
  rm -f ~/.bash_profile
  rm -f ~/.gitconfig
  rm -f ~/.githelpers
  rm -f ~/.gitignore_global
  rm -f ~/.jshintrc
  rm -f ~/.profile
  rm -f ~/.tmux.conf
  rm -rf ~/.vim
  rm -f ~/.vimrc
  rm -f ~/.zlogin
  rm -f ~/.zshrc
  rm -rf ~/bin
}
