function nix_update_packages {
  if type nix-channel &> /dev/null; then
    nix-channel --update && wait
  fi

  if type nix-env &> /dev/null; then
    nix-env -u && wait
  fi

  if type home-manager &> /dev/null; then
    home-manager switch && wait
  fi
}

alias ne="nix-env"
alias ns="nix-shell"
alias nc="nix-channel"
alias hm="home-manager"
