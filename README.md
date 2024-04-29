# DOTFILES

## Install Script

**dependencies**  
- zsh  
- curl  

```sh
zsh <(curl -s https://raw.githubusercontent.com/jacbart/dotfiles/main/installer.zsh)
```

**script installs**  
- nix  
  - stow  
- home-manager  
  - antidote  
  - htop  
  - tmux  
  - git  
  - jq  
  - fzf  
  - helix  
  - fd  
  - ripgrep  
  - age  
  - bitwarden-cli  
  - starship  

## Uninstall Script

```sh
~/.dotfiles/installer.zsh uninstall
```
