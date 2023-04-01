## ENV
export PIP_PATH="$HOME/Library/Python/3.8/lib/python/site-packages:$HOME/Library/Python/3.8/bin"
export BREW_PATH="/opt/homebrew/bin"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH:$BREW_PATH:$PIP_PATH"]
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

## Alias
alias copy="pbcopy"
alias grep="grep -RIns --color=auto --exclude=\"tags\""
alias ls="ls -G -l -h"
alias lsusb="system_profiler SPUSBDataType"
alias newmacaddr="openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//' | xargs sudo ifconfig en0 ether"
alias showhidden="defaults write com.apple.finder AppleShowAllFiles"
alias ctags="`brew --prefix`/bin/ctags"
alias update="brew update && brew upgrade && nix_update_packages"
alias install="brew install"
alias lastbackup="defaults read /Library/Preferences/com.apple.TimeMachine | rg ReferenceLocalSnapshotDate | awk '{print \$3}' | cut -d '\"' -f 2"

function cecho() {
  local code="\033["
  case "$1" in
    black  | bk) color="${code}0;30m";;
    red    |  r) color="${code}1;31m";;
    green  |  g) color="${code}1;32m";;
    yellow |  y) color="${code}1;33m";;
    blue   |  b) color="${code}1;34m";;
    purple |  p) color="${code}1;35m";;
    cyan   |  c) color="${code}1;36m";;
    gray   | gr) color="${code}0;37m";;
    *) local text="$1"
  esac
  [ -z "$text" ] && local text="$color$2${code}0m"
  echo "$text"
}

function lastm() {
  local last=`defaults read /Library/Preferences/com.apple.TimeMachine | rg ReferenceLocalSnapshotDate | awk '{print $3}' | cut -d '"' -f 2`
  local today=`date "+%Y-%m-%d"`
  local last=("${(@s/-/)last}")
  local today=("${(@s/-/)today}")
  local u=("year(s)" "month(s)" "day(s)")
  local uptodate=1
  for i in {1..3}; do
    if [[ "$today[$i]" > "$last[$i]"  ]]; then
      uptodate=0
      local diff=`expr $today[i] - $last[i]`
      if [[ "$i" == '3' ]]; then
        cecho y "$last[1]-$last[2]-$last[3] [$diff $u[$i] ago]"
        break
      else
        cecho r "$last[1]-$last[2]-$last[3] [$diff $u[$i] ago]"
        break
      fi
    fi
  done

  if [[ "$uptodate" == '1' ]]; then
    echo "$last[1]-$last[2]-$last[3]"
  fi
}

function remove() {
  brew rm $1
  brew rm $(join <(brew leaves) <(brew deps $1))
}

function reminder() {
  time sleep $2
  osascript -e "display notification \"$1\" with title \"Reminder\" sound name \"Ping\""
}

# Usage: $ notify Title content
function notify {
  osascript -e "display notification \"$2\" with title \"$1\" sound name \"Ping\""
}
