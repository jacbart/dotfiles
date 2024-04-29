###################
## ZSH Profiling ##
###################

# uncomment the below line and the last line in this file 'zprof' to enable zsh profiling
#zmodload zsh/zprof

###########################
## Environment Variables ##
###########################

export TERM=xterm-256color

# DOTFILES
export DOTFILES=${HOME}/.dotfiles
export ZDOTDIR=${DOTFILES}/shell

[ -f ${ZDOTDIR}/env.zsh ] && source ${ZDOTDIR}/env.zsh

############
## ALIAS' ##
############

[ -f ${ZDOTDIR}/alias.zsh ] && source ${ZDOTDIR}/alias.zsh

###################
## SHELL PLUGINS ##
###################

function zsh_plugin_refresh() {
  antibody bundle < ${ZDOTDIR}/zsh_plugins.txt > ${HOME}/.zsh_plugins.zsh
  chmod +x ${HOME}/.zsh_plugins.zsh
}

[ -f ${HOME}/.zsh_plugins.zsh ] && source ${HOME}/.zsh_plugins.zsh

#########
## NIX ##
#########

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
  source $HOME/.nix-profile/etc/profile.d/nix.sh;
  source ${ZDOTDIR}/nix.zsh
fi

if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix.sh ]; then
  source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
  source ${ZDOTDIR}/nix.zsh
fi

###################
## BITWARDEN-CLI ##
###################

if type bw &> /dev/null; then
  source ${ZDOTDIR}/bw.zsh
fi

####################
## SHELL SETTINGS ##
####################

HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

setopt autocd extendedglob notify
bindkey -e
zstyle :compinstall filename "$HOME/.zshrc"

# 0 -- vanilla completion (abc => abc)
# 1 -- smart case completion (abc => Abc)
# 2 -- word flex completion (abc => A-big-Car)
# 3 -- full flex completion (abc => ABraCadabra)
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'

# initialise completions with ZSH's compinit
if [ "$platform" = "Darwin" ]; then
  zcomp_date=$(stat -f '%Sm' -t '%j' ~/.zcompdump)
else
  zcomp_date=$(date -d "@$(stat -c '%Y' ~/.zcompdump)" +'%j')
fi
# ensure that the Zsh shell has the most up-to-date completion
autoload -Uz compinit
if [ $(date +'%j') != $zcomp_date ]; then
  compinit
else
  compinit -C
fi

# zsh-autosuggestion color highlighting and key bindings
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff5f00"
bindkey '^E' autosuggest-accept
bindkey '^ ' forward-word

###############
## Functions ##
###############

[ -f ${ZDOTDIR}/functions.zsh ] && source ${ZDOTDIR}/functions.zsh

##############
## STARSHIP ##
##############

if type "starship" &> /dev/null; then
  eval "$(starship init zsh)"
fi

############
## DIRENV ##
############

if type "direnv" &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

####################
## LOCAL OVERRIDE ##
####################

# add any overrides to .zshrc.local
source $HOME/.zshrc.local

#########
## FZF ##
#########

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

###################
## ZSH Profiling ##
###################

#zprof
