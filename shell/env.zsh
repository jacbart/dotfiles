# GO ENV
export GOPATH="$HOME/.go"
#export GOROOT="/usr/local/go"
#export GOROOT="$HOME/.nix-profile/share/go"
#export GOROOT="/etc/profiles/per-user/meep/bin/go"
export GOPRIVATE="github.com/journeyai,github.com/journeyid"

# Cargo
export CARGOPATH="$HOME/.cargo"

# PATH
export HOME_PATHS="$HOME/.local/bin:$HOME/bin"
export PATH="$PATH:$HOME_PATHS:/snap/bin:$GOROOT/bin:$GOPATH/bin:$CARGOPATH/bin"

# docker buildkit
export DOCKER_BUILDKIT=1

# nix path
export NIX_PATH="$HOME/.nix-defexpr/channels${NIX_PATH:+:$NIX_PATH}"

# Editor
export EDITOR="hx"

# stow package directory
export STOW_DIR="$HOME/.dotfiles/stowpkgs"

# Platform Specific
platform=$(uname)
if [ "$platform" = "Darwin" ]; then
  [ -f ${ZDOTDIR}/macos.zsh ] && source ${ZDOTDIR}/macos.zsh
else
  # get linux distro ID
  export DISTRO_ID=$(cat /etc/*release | grep '^ID=' | sed 's/^ID=*//')

  # load linux shell alias' and funcs
  [ -f ${ZDOTDIR}/linux.zsh ] && source ${ZDOTDIR}/linux.zsh

  # if os is NixOS
  if [ "$DISTRO_ID" = "nixos" ]; then
    source ${ZDOTDIR}/nix.zsh
  fi
fi
