{ config, pkgs, ... }:

{
  home.username = "USER";
  home.homeDirectory = "/Users/${config.home.username}";

  home.packages = with pkgs; [
    htop
    tmux
    git
    jq
    fzf
    neovim
    fd
    ripgrep
  ];

  programs.go = {
    enable = true;
    package = pkgs.go_1_17;
  };

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;
}
