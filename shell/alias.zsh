alias vim="nvim"
alias kc="kubectl"
alias sys="systemctl"
alias ssys="sudo systemctl"
alias nc="ncat"
alias fw="sudo firewall-cmd"
alias t="tmux"
alias j="z"
alias gs="git status"


# Platform Specific
platform=$(uname)
if [ "$platform" = "Darwin" ]; then
  [[ ! -f $DOTFILES/shell/macos.zsh ]] || source $DOTFILES/shell/macos.zsh
else
  [[ ! -f $DOTFILES/shell/linux.zsh ]] || source $DOTFILES/shell/linux.zsh
fi

[[ ! -f $DOTFILES/shell/asdf.zsh ]] || source $DOTFILES/shell/asdf.zsh
