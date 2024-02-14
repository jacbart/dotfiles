#!/bin/zsh

export STOW_DIR="$HOME/.dotfiles/stowpkgs"
alias st="stow -v -t $HOME"

function install_nix {
  if type nix &> /dev/null; then
    echo "Skipping Nix install"
  else
    # https://zero-to-nix.com/start/install
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    # Install nixpkgs unstable channel
    nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
    nix-channel --update nixpkgs
  fi
  if ! type stow &> /dev/null; then
    nix profile install 'nixpkgs#stow'
  fi
  if [ ! -e $HOME/.config/nix/nix.conf ]; then
    st -S nix --no-folding
  fi
  if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
    source $HOME/.nix-profile/etc/profile.d/nix.sh;
  fi
  if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi
}

function install_home_manager {
  export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:$NIX_PATH}
  if type home-manager &> /dev/null; then
    echo "Skipping home-manager install"
  else
    echo "Installing home-manager"
    # Install home-manager channel
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update home-manager

    # Install home-manager
    nix-shell '<home-manager>' -A install
  fi
  # Platform Specific home.nix linking
  rm -rf $HOME/.config/home-manager
  mkdir -p $STOW_DIR/home-manager/.config/home-manager
  platform=$(uname)
  if [ "$platform" = "Darwin" ]; then
    sed "s/USER/$USER/" $HOME/.dotfiles/config/nix/home-manager/home.nix > $STOW_DIR/home-manager/.config/home-manager/home.nix
  else
    cp $HOME/.dotfiles/config/nix/home-manager/home.nix $STOW_DIR/home-manager/.config/home-manager/home.nix
    sed -i "s/USER/$USER/" $STOW_DIR/home-manager/.config/home-manager/home.nix
  fi
  st -S home-manager
  
  home-manager build && wait
  home-manager switch && wait
}

function install() {
  # Download dotfiles
  git clone https://github.com/jacbart/dotfiles.git $HOME/.dotfiles

  if type zsh &> /dev/null; then
    install_nix && wait
    if ! type stow &> /dev/null; then
      nix profile install 'nixpkgs#stow'
    fi
    install_home_manager && wait

    # Link zsh configs
    echo "removing old zshrc"
    rm -f  $HOME/.zshrc
    echo "touching zshrc.local"
    touch $HOME/.zshrc.local
    [[ -f $HOME/.tmux.conf ]] && rm -f $HOME/.tmux.conf
    st -S shell

    # Adding common directories
    echo "ensuring $HOME/workspace"
    [[ ! -d $HOME/workspace ]] && mkdir $HOME/workspace
    echo "ensuring $HOME/workspace/personal/notes"
    [[ ! -d $HOME/workspace/personal/notes ]] && mkdir -p $HOME/workspace/personal/notes
    echo "ensuring $HOME/bin"
    [[ ! -d $HOME/bin ]] && mkdir $HOME/bin
    echo "ensuring $HOME/.ssh"
    [[ ! -d $HOME/.ssh ]] && mkdir $HOME/.ssh

    # Setup git-switcher configs
    if [[ ! -d $HOME/.config/gitconfigs ]]; then
      st -S gitconfigs --no-folding
      echo "run: go install github.com/theykk/git-switcher@latest to install git switcher"
    else
      st -R gitconfigs --no-folding
    fi

    if type hx &> /dev/null; then
      echo "removing old helix config"
      [[ -d $HOME/.config/helix ]] && rm -rf $HOME/.config/helix
      st -S helix
    fi

    if type tmux &> /dev/null; then
      echo "ensuring tmux package manager"
      [[ ! -d $HOME/.tmux ]] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi

    if type wezterm &> /dev/null; then
      echo "removing old wezterm config"
      [[ -f $HOME/.wezterm.lua ]] && rm -f $HOME/.wezterm.lua
      st -S wezterm
    fi

    if type "antibody" &> /dev/null; then
      antibody bundle < $HOME/.dotfiles/shell/antibody_plugins.txt > $HOME/.antibody_plugins.sh
      chmod +x $HOME/.antibody_plugins.sh
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

function uninstall {
  pushd $STOW_DIR
  for f in *; do
    if [ -d "$f" ]; then
        echo "Uninstalling $f"
        st -D $f
    fi
  done
  popd
  rm -rf $HOME/.config/nix
  rm -rf $HOME/.config/gitconfigs
  rm -f $HOME/.antibody_plugins.sh
  rm -rf $HOME/.tmux
  rm -rf $HOME/.dotfiles

  nix-channel --remove home-manager
  nix-channel --remove nixpkgs
  /nix/nix-installer uninstall
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
  yes_or_no "$message" && uninstall && install
else
  install
fi
