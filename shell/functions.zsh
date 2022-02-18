if type kubectl &> /dev/null; then
  [[ -f $DOTFILES/shell/kubectl.zsh ]] && source $DOTFILES/shell/kubectl.zsh
fi

function kp {
  local pid=$(ps -ef | sed 1d | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[kill:process]'" | awk '{print $2}')
  if [ "x$pid" != "x" ]; then
    echo $pid | xargs kill -${1:-9}
  fi
}
