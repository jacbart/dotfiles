#!/bin/zsh

function install_nix {
  if type nix &> /dev/null; then
    echo "Skipping Nix install"
  else
    # Platform Specific install Nix
    platform=$(uname)
    if [ "$platform" = "Darwin" ]; then
      echo "Installing Nix Package Manager"
      sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume --daemon
      wait
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
    sed "s/USER/$USER/" $HOME/.dotfiles/config/home-manager/mac-home.nix > $HOME/.dotfiles/config/current-home.nix
    ln -s $HOME/.dotfiles/config/current-home.nix $HOME/.config/nixpkgs/home.nix
  else
    cp $HOME/.dotfiles/config/home-manager/linux-home.nix $HOME/.dotfiles/config/current-home.nix
    sed -i "s/USER/$USER/" $HOME/.dotfiles/config/current-home.nix
    ln -s $HOME/.dotfiles/config/current-home.nix $HOME/.config/nixpkgs/home.nix
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
    echo "removing old zshrc"
    rm -f  $HOME/.zshrc
    echo "linking new zshrc"
    ln -s $HOME/.dotfiles/shell/zshrc $HOME/.zshrc
    echo "touching zshrc.local"
    touch $HOME/.zshrc.local

    # Adding common directories
    echo "ensuring $HOME/workspace"
    [[ ! -d $HOME/workspace ]] && mkdir $HOME/workspace
    echo "ensuring $HOME/bin"
    [[ ! -d $HOME/bin ]] && mkdir $HOME/bin
    echo "ensuring $HOME/.ssh"
    [[ ! -d $HOME/.ssh ]] && mkdir $HOME/.ssh

    # Setup git-switcher configs
    if [[ ! -d $HOME/.config/gitconfigs ]]; then
      echo "linking gitconfigs for git switcher"
      mkdir -p $HOME/.config/gitconfigs
      ln -s $HOME/.dotfiles/config/gitconfigs/* $HOME/.config/gitconfigs/
      echo "run: go install github.com/theykk/git-switcher@latest to install git switcher"
    fi

    # Setup asdf version manager configs
    # [[ ! -d $HOME/.asdf ]] && git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.9.0
    # echo "ensuring $HOME/.asdfrc"
    [[ ! -f $HOME/.asdfrc ]] && ln -s $HOME/.dotfiles/config/asdf/asdfrc $HOME/.asdfrc
    echo "ensuring $HOME/.tool-versions"
    [[ ! -f $HOME/.tool-versions ]] && ln -s $HOME/.dotfiles/config/asdf/tool-versions $HOME/.tool-versions

    if type nvim &> /dev/null; then
      echo "removing old neovim configs"
      [[ -d $HOME/.config/nvim ]] && rm -rf  $HOME/.config/nvim
      echo "linking new neovim configs"
      ln -s $HOME/.dotfiles/config/nvim $HOME/.config/
    fi
    
    if type hx &> /dev/null; then
      echo "removing old helix config"
      [[ -d $HOME/.config/helix ]] && rm -rf $HOME/.config/helix
      echo "linking new helix configs"
      ln -s $HOME/.dotfiles/config/helix $HOME/.config/
    fi

    if type tmux &> /dev/null; then
      echo "removing old tmux config"
      [[ -f $HOME/.tmux.conf ]] && rm -f $HOME/.tmux.conf
      echo "ensuring tmux package manager"
      [[ ! -d $HOME/.tmux ]] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
      echo "linking new tmux config"
      ln -s $HOME/.dotfiles/config/tmux/tmux.conf $HOME/.tmux.conf
    fi

    if type kitty &> /dev/null; then
      echo "removing old kitty config"
      [[ -d $HOME/.config/kitty ]] && rm -rf  $HOME/.config/kitty
      mkdir -p $HOME/.config/kitty
      echo "linking new kitty config"
      ln -s $HOME/.dotfiles/config/kitty/kitty.conf $HOME/.config/kitty/kitty.conf
    fi

    if type wezterm &> /dev/null; then
      echo "removing old wezterm config"
      [[ -f $HOME/.wezterm.lua ]] && rm -f $HOME/.wezterm.lua
      echo "linking new wezterm config"
      ln -s $HOME/.dotfiles/config/wezterm/wezterm.lua $HOME/.wezterm.lua
    fi

    source $HOME/.zshrc

    if ! type git-switcher &> /dev/null; then
      # Install git switcher
      export GOPATH="$HOME/.go"
      export GOROOT="$HOME/.nix-profile/share/go"
      echo "installing git-switcher"
      go install github.com/theykk/git-switcher@latest
    fi
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
