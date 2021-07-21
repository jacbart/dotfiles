alias ls="ls -lh --color=auto"
alias la="ls -lah --color=auto"
alias vim="nvim"
alias kc="kubectl"
alias sys="systemctl"
alias ssys="sudo systemctl"
alias nc="ncat"
alias fw="sudo firewall-cmd"
alias t="tmux"
alias j="z"
alias gs="git status"
if [[ $(cat /proc/sys/kernel/osrelease | grep microsoft) ]]; then
  alias copy="clip.exe" #windows
else
  alias copy="xclip -sel clip" #linux
fi

[[ ! -f $DOTFILES/shell/linux.zsh ]] || source $DOTFILES/shell/linux.zsh

[[ ! -f $DOTFILES/shell/asdf.zsh ]] || source $DOTFILES/shell/asdf.zsh