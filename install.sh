#!/bin/bash

function install() {
    git clone https://github.com/jacbart/dotfiles.git $HOME/.dotfiles

    if type zsh &> /dev/null; then
        rm -f  $HOME/.zshrc
        ln -s $HOME/.dotfiles/shell/zshrc $HOME/.zshrc
        touch $HOME/.zshrc.local

        [[ -d $HOME/workspace ]] || mkdir $HOME/workspace
        [[ -d $HOME/bin ]] || mkdir $HOME/bin
        
        if type nvim &> /dev/null; then
            [[ -d $HOME/.config/nvim ]] && rm -rf  $HOME/.config/nvim
            mkdir -p $HOME/.config/nvim
            ln -s $HOME/.dotfiles/config/init.vim $HOME/.config/nvim/init.vim
        fi

        if type kitty &> /dev/null; then
            [[ -d $HOME/.config/kitty ]] && rm -rf  $HOME/.config/kitty
            mkdir -p $HOME/.config/kitty
            ln -s $HOME/.dotfiles/config/kitty.conf $HOME/.config/kitty/kitty.conf
        fi

        source $HOME/.zshrc
    else
        echo "missing zsh"
    fi
}

function yes_or_no {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;  
            [Nn]*) echo "Aborted" ; return  1 ;;
        esac
    done
}

if [[ -d $HOME/.dotfiles ]]; then
    message="~/.dotfiles already exists, would you like to remove and install again?"
    yes_or_no "$message" && rm -rf "$HOME/.dotfiles" && install
else
    install
fi