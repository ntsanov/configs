#!/bin/bash
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
ln -s ~/.ntsanov-configs/.vimrc ~/.vimrc
ln -s ~/.ntsanov-configs/.vim/startup ~/.vim/startup
vim +PluginInstall +qall
