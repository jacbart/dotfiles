{ config, pkgs, ... }:

{
  home.username = "meep";
  home.homeDirectory = "/home/${config.home.username}";

  targets.genericLinux.enable = true;

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
    goPath = "${config.home.homeDirectory}/.go";
  };

  home.stateVersion = "22.05";

  services.home-manager.autoUpgrade = {
    enable = true;
    frequency = "weekly";
  };

  programs.home-manager.enable = true;
}