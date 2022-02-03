#!/bin/zsh

function install() {
    # Download dotfiles
    git clone https://github.com/jacbart/dotfiles.git $HOME/.dotfiles

    # Platform Specific install Nix
    platform=$(uname)
    if [ "$platform" = "Darwin" ]; then
        sh <(curl -L https://nixos.org/nix/install)
    else
        sh <(curl -L https://nixos.org/nix/install) --no-daemon
    fi
    if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi

    # Install channels
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
    nix-channel --update

    export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:$NIX_PATH}
    # Install home-manager
    nix-shell '<home-manager>' -A install
    rm $HOME/.config/nixpkgs/home.nix
    ln -s $HOME/.dotfiles/config/home.nix $HOME/.config/nixpkgs/home.nix
    home-manager switch

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
            ln -s $HOME/.dotfiles/config/nvim $HOME/.config/
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
