function open {
  xdg-open "$@" >/dev/null 2>&1
}

source ./nix.zsh

alias ls="ls -lh --color=auto"
alias la="ls -lah --color=auto"

if [[ $(cat /proc/sys/kernel/osrelease | grep microsoft) ]]; then
  alias copy="clip.exe" #windows
else
  alias copy="xclip -sel clip" #linux
fi

if [ -f /etc/debian_version ]; then
  alias update="sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade && sudo apt-get autoremove && nix_update_packages"
  alias install="sudo apt-get install"
  alias remove="sudo apt-get autoremove"

  xmodmap ~/.xmodmap > /dev/null 2>&1

elif [ -f /etc/redhat-release ]; then
  alias update="sudo dnf update && nix_update_packages"
  alias install="sudo dnf install"
  alias remove="sudo dnf remove"
elif [ -f /etc/arch-release ]; then
  alias update="yay -Syu && nix_update_packages"
  alias install="yay -S"
  alias remove="yay -Rcns"
elif `grep -Fq Amazon /etc/system-release 2> /dev/null`; then
  alias update="sudo yum update && nix_update_packages"
  alias install="sudo yum install"
  alias remove="sudo yum remove"
elif [ -f /etc/alpine-release ]; then
  alias update="sudo apk update && nix_update_packages"
  alias install="sudo apk add"
  alias remove="sudo apk del"
fi
