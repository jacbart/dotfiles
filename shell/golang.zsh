
function install_golang() {
  VERSION=$1
  unameOut="$(uname -s)"
  case "${unameOut}" in
    Linux*)
      dl_url="https://golang.org/dl/go$VERSION.linux-amd64.tar.gz"
      curl -LO $dl_url
      sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go$VERSION.linux-amd64.tar.gz
      rm go$VERSION.linux-amd64.tar.gz;;
    Darwin*)
      dl_url="https://golang.org/dl/go$VERSION.darwin-amd64.pkg"
      curl -LO $dl_url;;
    CYGWIN*)
      dl_url=Cygwin
      echo "$dl_url";;
    MINGW*)
      dl_url=MinGw
      echo "$dl_url";;
    *)
      echo "UNKNOWN:${unameOut}";;
  esac
}

alias updatego="sudo install_golang"
