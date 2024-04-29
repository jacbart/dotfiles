if type kubectl &> /dev/null; then
  [ -f ${ZDOTDIR}/kubectl.zsh ] && source ${ZDOTDIR}/kubectl.zsh
fi

function kp {
  local pid=$(ps -ef | sed 1d | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[kill:process]'" | awk '{print $2}')
  if [ "x$pid" != "x" ]; then
    echo $pid | xargs kill -${1:-9}
  fi
}

# TUNNEL=
# INTERNAL_PORT=9000
# tunnel () {
#         echo "forwarding $1..." 
#         \ssh root@$TUNNEL 'pkill -o -u $USER sshd'
#         \ssh -o "ExitOnForwardFailure yes" -N -R $INTERNAL_PORT:localhost:$1 root@$TUNNEL
# }

function jawson {
  export JAWS_CONFIG_KEY=$(op item get JAWS_CONFIG_KEY --fields label=password)
}

function jawsoff {
  unset JAWS_CONFIG_KEY
}

function jaws-op {
  JAWS_CONFIG_KEY=$(op item get JAWS_CONFIG_KEY --fields label=password) koi "$@"
}
#alias jaws=jaws-op