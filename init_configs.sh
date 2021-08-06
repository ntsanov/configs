#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

rm -rf ~/.config/nvim
rm -rf ~/.config/fontconfig
rm -rf ~/.zshrc

ln -s ${DIR}/.config/nvim ~/.config/nvim
ln -s ${DIR}/.config/fontconfig ~/.config/fontconfig
ln -s ${DIR}/.zshrc ~/.zshrc