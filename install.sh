#!/bin/zsh

function install_nix {
  # Platform Specific install Nix
  platform=$(uname)
  if [ "$platform" = "Darwin" ]; then
    sed -iE "s/USER/$USER/" $HOME/.dotfiles/config/home.nix
    if type nix &> /dev/null; then
      echo "Skipping Nix install"
    else
      echo "Installing Nix Package Manager"
      sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume --daemon
      wait
    fi
  else
    sed -i "s/USER/$USER/" $HOME/.dotfiles/config/home.nix
    if type nix &> /dev/null; then
      echo "Skipping Nix install"
    else
      echo "Installing Nix Package Manager"
      sh <(curl -L https://nixos.org/nix/install) --no-daemon
      wait
    fi
  fi
  if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
    source $HOME/.nix-profile/etc/profile.d/nix.sh;
  fi
}

function install_home_manager {
  export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:$NIX_PATH}
  if type home-manager &> /dev/null; then
    echo "Skipping home-manager install"
  else
    echo "Installing home-manager"
    # Install channels
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
    nix-channel --update

    # Install home-manager
    nix-shell '<home-manager>' -A install
  fi
  # Platform Specific home.nix linking
  rm $HOME/.config/nixpkgs/home.nix
  platform=$(uname)
  if [ "$platform" = "Darwin" ]; then
    ln -s $HOME/.dotfiles/config/mac-home.nix $HOME/.config/nixpkgs/home.nix
  else
    ln -s $HOME/.dotfiles/config/linux-home.nix $HOME/.config/nixpkgs/home.nix
  fi
  
  home-manager build && wait
  home-manager switch && wait
}

function install() {
  # Download dotfiles
  git clone https://github.com/jacbart/dotfiles.git $HOME/.dotfiles

  if type zsh &> /dev/null; then
    install_nix && wait
    install_home_manager && wait
    

    # Link zsh configs
    rm -f  $HOME/.zshrc
    ln -s $HOME/.dotfiles/shell/zshrc $HOME/.zshrc
    touch $HOME/.zshrc.local

    # Adding common directories
    [[ -d $HOME/workspace ]] || mkdir $HOME/workspace
    [[ -d $HOME/bin ]] || mkdir $HOME/bin
    [[ -d $HOME/.ssh ]] || mkdir $HOME/.ssh

    # Setup git-switcher configs
    if [[ ! -d $HOME/.config/gitconfigs ]]; then
      mkdir -p $HOME/.config/gitconfigs
      ln -s $HOME/.dotfiles/config/gitconfigs/* $HOME/.config/gitconfigs/
      echo "run: go install github.com/theykk/git-switcher@latest"
    fi

    # Setup asdf version manager configs
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

    # Install git switcher
    export GOPATH="$HOME/.go"
    export GOROOT="/usr/local/go"
    go install github.com/theykk/git-switcher@latest
  else
    echo "missing zsh"
  fi
}

function yes_or_no {
  while true; do
    read -q yn\?"$* [y/n]: "
    case $yn in
      [Yy]*) echo "" ; return 0  ;;
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
