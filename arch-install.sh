#!/usr/bin/env bash

# Install common tools.
pacman -S bat eza duf fd fish fzf ripgrep lsd
pacman -S ttf-sourcecodepro-nerd neovim alacritty ghostty

# Make Alacritty+neovim default text editor.
xdg-mime default Alacritty-nvim.desktop text/plain

