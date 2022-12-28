# GO ENV
export GOPATH="$HOME/.go"
#export GOROOT="/usr/local/go"
export GOROOT="$HOME/.nix-profile/share/go"
export GOPRIVATE="github.com/journeyai,github.com/journeyid"

# Cargo
export CARGOPATH="$HOME/.cargo"

# PATH
export HOME_PATHS="$HOME/.local/bin:$HOME/bin"
export PATH="$PATH:$HOME_PATHS:/snap/bin:$GOROOT/bin:$GOPATH/bin:$CARGOPATH/bin"

# docker buildkit
export DOCKER_BUILDKIT=1

# nix path
export NIX_PATH="$HOME/.nix-defexpr/channels${NIX_PATH:+:$NIX_PATH}"
