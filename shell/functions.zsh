if type kubectl &> /dev/null; then
  [[ -f $DOTFILES/shell/kubectl.zsh ]] && source $DOTFILES/shell/kubectl.zsh
fi

function kp {
  local pid=$(ps -ef | sed 1d | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[kill:process]'" | awk '{print $2}')
  if [ "x$pid" != "x" ]; then
    echo $pid | xargs kill -${1:-9}
  fi
}

function tunnel {
  echo "forwarding $1..."
  \ssh -o "ExitOnForwardFailure yes" -N -R 9000:localhost:$1 root@proxy.meep.sh -i $HOME/.ssh/id_meep_web 
}

function koion {
  export KOI_CONFIG_KEY=$(op item get KOI_CONFIG_KEY --fields label=password)
}

function koioff {
  unset KOI_CONFIG_KEY
}

function koi-op {
  KOI_CONFIG_KEY=$(op item get KOI_CONFIG_KEY --fields label=password) koi "$@"
}
#alias koi=koi-op

