#!/bin/bash
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ln -s ${DIR}/.vimrc ~/.vimrc
ln -s ${DIR}/.vim/startup ~/.vim/startup
vim +PluginInstall +qall
