#!/bin/zsh

function install() {
    git clone https://github.com/jacbart/dotfiles.git $HOME/.dotfiles

    if type zsh &> /dev/null; then
        rm -f  $HOME/.zshrc
        ln -s $HOME/.dotfiles/shell/zshrc $HOME/.zshrc
        touch $HOME/.zshrc.local

        [[ -d $HOME/workspace ]] || mkdir $HOME/workspace
        [[ -d $HOME/bin ]] || mkdir $HOME/bin
        [[ -d $HOME/.ssh ]] || mkdir $HOME/.ssh
        if [[ ! -d $HOME/.config/gitconfigs ]]; then
            mkdir -p $HOME/.config/gitconfigs
            ln -s $HOME/.dotfiles/config/gitconfigs/* $HOME/.config/gitconfigs/
            echo "run: go install github.com/theykk/git-switcher@latest"
        fi
        [[ -f $HOME/.asdfrc ]] || ln -s $HOME/.dotfiles/config/asdfrc $HOME/.asdfrc
        [[ -f $HOME/.tool-versions ]] || ln -s $HOME/.dotfiles/config/asdf_tool-versions $HOME/.tool-versions

        if type nvim &> /dev/null; then
            [[ -d $HOME/.config/nvim ]] && rm -rf  $HOME/.config/nvim
            mkdir -p $HOME/.config/nvim
            ln -s $HOME/.dotfiles/config/init.vim $HOME/.config/nvim/init.vim
        fi

        if type tmux &> /dev/null; then
            [[ -f $HOME/.tmux.conf ]] && rm -f  $HOME/.tmux.conf
            [[ ! -d $HOME/.tmux ]] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
            ln -s $HOME/.dotfiles/config/tmux.conf $HOME/.tmux.conf
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
        read -q yn\?"$* [y/n]: "
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