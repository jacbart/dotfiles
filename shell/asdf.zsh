[[ $(type "curl" &> /dev/null) ]] && install curl -y
[[ $(type "git" &> /dev/null) ]] && install git -y

[[ -d $HOME/.asdf ]] || git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1

. $HOME/.asdf/asdf.sh