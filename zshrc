#############
## ANTIGEN ##
#############
if [[ ! -a $HOME/.antigen.zsh ]]; then
  curl -L git.io/antigen > $HOME/.antigen.zsh
fi

source $HOME/.antigen.zsh

antigen theme romkatv/powerlevel10k

antigen use oh-my-zsh

antigen bundle git
antigen bundle terraform
antigen bundle docker
antigen bundle docker-compose
antigen bundle systemd
antigen bundle helm
antigen bundle kubectl
antigen bundle golang
antigen bundle ansible
antigen bundle z
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions
antigen bundle sudo
antigen bundle fzf
antigen bundle command-not-found

antigen apply

###############

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

###############
## Variables ##
###############

# GOVC environment variables
export GOVC_USERNAME="jbartlett@denver.journey"
export GOVC_PASSWORD=""
export GOVC_URL="https://vcsa.denver.journey"
export GOVC_INSECURE="true"

# Androidsdk from Snap install 
export ANDROID_SDK_ROOT=$HOME/snap/androidsdk/current/AndroidSDK

# GO ENV
export GOPATH="$HOME/.go"
export GOROOT="/usr/local/go"
export GOPRIVATE=github.com/journeyai

# Export PATH
HOME_PATHS="$HOME/.local/bin:/$HOME/bin"
export PATH="$PATH:$HOME_PATHS:/snap/bin:$GOROOT/bin:$GOPATH/bin"

# docker buildkit
export DOCKER_BUILDKIT=1

# fix ssh issue with kitty terminal
export TERM=xterm-256color

###############

# from zsh configuration script
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt autocd extendedglob notify
bindkey -e
zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit
compinit
if command -v kitty &> /dev/null; then
    kitty + complete setup zsh | source /dev/stdin
fi

# minio client - auto complete
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C $HOME/.go/bin/mc mc

# zsh-autosuggestion color highlighting and key bindings
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff5f00"
bindkey '^E' autosuggest-accept
bindkey '^ ' forward-word

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


###############
## Functions ##
###############

# kubernetes triage script
function triage() {
  namespace=${1:-default}

  config=https://raw.githubusercontent.com/taybart/dotfiles/master/triage.yaml
  kubectl apply -n $namespace -f $config
  msg="waiting for pod"
  waittime=0
  echo -n "$msg ${waittime}s"
  while [[ $(kubectl get -n $namespace pod/triage -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
    sleep 1
    ((waittime++))
    printf "\r$msg ${waittime}s"
  done
  printf "\n"

  kubectl exec -n $namespace -ti triage -- /bin/zsh
  kubectl delete -n $namespace -f $config
}

# kubernetes context management function
function kcxt() {
  if [[ -z $1 ]]; then
      kubectl config get-contexts
  elif [[ $# -ge 1 ]]; then
    case "$1" in
      "ns" | "namespace" | "-ns" | "-namespace")
        kubectl config set-context --current --namespace="$2"
      ;;
      *)
        kubectl config use-context "$1"
      ;;
    esac
  fi
}

# kubernetes remove evicted pods
function kc-remove-evicted() {
  kubectl get pod --all-namespaces -o json | \
  jq  '.items[] | select(.status.reason!=null) | select(.status.reason | contains("Evicted")) | "kubectl delete po \(.metadata.name) -n \(.metadata.namespace)"' | \
  xargs -n 1 bash -c
}

# kubernetes remove a namespace that is stuck in terminating state
function namespace-force-remove() {
  if [[ -z $1 ]]; then
    echo "choose namespace"
  else
    NAMESPACE=$1
    kubectl get namespaces $NAMESPACE -o json | jq '.spec.finalizers=[]' > /tmp/ns.json
    kubectl proxy &
    PROXY_PID=$!
    curl -k -H "Content-Type: application/json" -X PUT --data-binary @/tmp/ns.json http://127.0.0.1:8001/api/v1/namespaces/$NAMESPACE/finalize
    sleep 2s
    kill $PROXY_PID
  fi
}

# kubernetes enter pod shell
function kc-shell() {
  if [[ $# != 2 ]]; then
    echo "usage: kc-shell <Pod Name> <Namespace>"
  else
    PODNAME=$1
    NAMESPACE=$2
    kubectl exec -ti $PODNAME -n $NAMESPACE -- sh
  fi
}

function ge() {
  if [[ $# != 1 ]]; then
    echo "usage: ge <email>"
  else
    case "$1" in
      "jry")
        EMAIL="jack.bartlett@journeyid.com"
        git config user.email "$EMAIL"
      ;;
      "jack")
        EMAIL="jacbart@gmail.com"
        git config user.email "$EMAIL"
      ;;
      *)
        echo "not an option"
      ;;
    esac
  fi
}

############
## ALIAS' ##
############

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
alias copy="xclip -sel clip"
