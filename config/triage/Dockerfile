FROM nixos/nix

WORKDIR /root
USER root

RUN nix-channel --update
RUN nix-env -iA \
  nixpkgs.curl \
  nixpkgs.antibody \
  nixpkgs.zsh \
  nixpkgs.fzf \
  nixpkgs.jq \
  nixpkgs.dig \
  nixpkgs.ripgrep \
  nixpkgs.neovim


ADD *.nix .
ADD zshrc .zshrc

CMD ["nix-shell", "--command", "zsh"]
