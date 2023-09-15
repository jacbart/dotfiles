function nix_update_packages {
  if type nix-channel &> /dev/null; then
    nix-channel --update && wait
  fi

  if type nix &> /dev/null; then
    nix profile upgrade '.*' && wait
  fi

  if type home-manager &> /dev/null; then
    home-manager switch && wait
  fi
}

function nixos_rebuild {
  HOSTNAME=$(hostnamectl hostname)
  pushd $DOTFILES/config/nix &> /dev/null
  nix flake lock --update-input nixpkgs
  sudo nixos-rebuild switch --flake ".#$HOSTNAME"
  popd &> /dev/null
}

alias hm="home-manager"
