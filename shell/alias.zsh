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
alias copy="xclip -sel clip" #linux
#alias copy="clip.exe" #windows
alias as="ansible"
alias ap="ansible-playbook"
alias av="ansible-vault"

[[ ! -f $DOTFILES/shell/linux.zsh ]] || source $DOTFILES/shell/linux.zsh