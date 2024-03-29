###################
## ZSH Profiling ##
###################

# uncomment the below line and the last line in this file 'zprof' to enable zsh profiling
#zmodload zsh/zprof

###############
## Variables ##
###############

export TERM=xterm-256color
export DOTFILES="$HOME/.dotfiles"

[[ ! -f $DOTFILES/shell/env.zsh ]] || source $DOTFILES/shell/env.zsh

# Platform Specific
platform=$(uname)
if [ "$platform" = "Darwin" ]; then
  [[ ! -f $DOTFILES/shell/macos.zsh ]] || source $DOTFILES/shell/macos.zsh
else
  # get linux distro ID
  export DISTRO_ID=$(cat /etc/*release | grep '^ID=' | sed 's/^ID=*//')

  # load linux shell alias' and funcs
  [[ ! -f $DOTFILES/shell/linux.zsh ]] || source $DOTFILES/shell/linux.zsh

  # if os is NixOS
  if [ "$DISTRO_ID" = "nixos" ]; then
    source $DOTFILES/shell/nix.zsh
  fi
fi

############
## ALIAS' ##
############

[[ ! -f $DOTFILES/shell/alias.zsh ]] || source $DOTFILES/shell/alias.zsh

##############
## ANTIBODY ##
##############

function zsh_plugin_refresh() {
  antibody bundle < $DOTFILES/shell/antibody_plugins.txt > $HOME/.antibody_plugins.sh
  chmod +x $HOME/.antibody_plugins.sh
}

if ! type "antibody" &> /dev/null; then
  $DOTFILES/shell/get_antibody.sh -b $HOME/.local/bin
  zsh_plugin_refresh
fi


source $HOME/.antibody_plugins.sh

#########
## NIX ##
#########

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
  source $HOME/.nix-profile/etc/profile.d/nix.sh;
  source $DOTFILES/shell/nix.zsh
fi

if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix.sh ]; then
  source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
  source $DOTFILES/shell/nix.zsh
fi

##########
## ASDF ##
##########

if type asdf &> /dev/null; then
  if [ "$platform" = "Darwin" ]; then
    asdf_source=$(readlink -f $(which asdf) | sed 's/bin\/asdf/share\/asdf-vm\/asdf.sh/')
    source $asdf_source
  else
    asdf_source="/nix/store/4d45jv3131knk480986hj4jw477zsh7b-asdf-vm-0.12.0/share/asdf-vm/asdf.sh"
    source $asdf_source
  fi

  # append completions to fpath
  fpath=(${ASDF_DIR}/completions $fpath)
fi

###################
## BITWARDEN-CLI ##
###################

if type bw &> /dev/null; then
  source $DOTFILES/shell/bw.zsh
fi

###############

# from zsh configuration script
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt autocd extendedglob notify
bindkey -e
zstyle :compinstall filename "$HOME/.zshrc"

# auto complete for ani
#[[ -f ~/.config/ani/ani.conf ]] && mkdir -p ${fpath[1]} && touch "${fpath[1]}/_ani" && ani gen completion zsh > "${fpath[1]}/_ani"

# initialise completions with ZSH's compinit
if [ "$platform" = "Darwin" ]; then
  zcomp_date=$(stat -f '%Sm' -t '%j' ~/.zcompdump)
else
  zcomp_date=$(date -d "@$(stat -c '%Y' ~/.zcompdump)" +'%j')
fi

autoload -Uz compinit
if [ $(date +'%j') != $zcomp_date ]; then
  compinit
else
  compinit -C
fi

# Kitty terminal
#if type kitty &> /dev/null; then
#  kitty + complete setup zsh | source /dev/stdin
#fi

# zsh-autosuggestion color highlighting and key bindings
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff5f00"
bindkey '^E' autosuggest-accept
bindkey '^ ' forward-word

###############
## Functions ##
###############

[ -f $DOTFILES/shell/functions.zsh ] && source $DOTFILES/shell/functions.zsh 

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

############

# add any overrides to .zshrc.local
source $HOME/.zshrc.local

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

###################
## ZSH Profiling ##
###################

#zprof
