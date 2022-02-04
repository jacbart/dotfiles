source ./nix.zsh 

export PIP_PATH="$HOME/Library/Python/3.8/lib/python/site-packages:$HOME/Library/Python/3.8/bin"
export BREW_PATH="/opt/homebrew/bin"
export PATH="$PATH:$BREW_PATH:$PIP_PATH"
alias copy="pbcopy"
alias grep="grep -RIns --color=auto --exclude=\"tags\""
alias ls="ls -G -l -h"
alias lsusb="system_profiler SPUSBDataType"
alias newmacaddr="openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//' | xargs sudo ifconfig en0 ether"
alias showhidden="defaults write com.apple.finder AppleShowAllFiles"
alias ctags="`brew --prefix`/bin/ctags"
alias update="brew update && brew upgrade && update_nix_packages"
alias install="brew install"
function remove() {
  brew rm $1
  brew rm $(join <(brew leaves) <(brew deps $1))
}
function title {
  echo -ne "\033]0;"$*"\007"
}
# Usage: $ notify Title content
function notify {
  osascript -e "display notification \"$2\" with title \"$1\" sound name \"Ping\""
}
