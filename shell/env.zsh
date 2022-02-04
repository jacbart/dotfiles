# Ansible Path
# export ANSIBLE_PATH="$HOME/workspace/lodestone"

# GOVC environment variables
# export GOVC_USERNAME="jbartlett@denver.journey"
# export GOVC_PASSWORD=""
# export GOVC_URL="https://vcsa.denver.journey"
# export GOVC_INSECURE="true"

# Androidsdk from Snap install
# export ANDROID_SDK_ROOT=$HOME/snap/androidsdk/current/AndroidSDK

# GO ENV
export GOPATH="$HOME/.go"
#export GOROOT="/usr/local/go"
export GOROOT="$HOME/.nix-profile/share/go"
export GOPRIVATE=github.com/journeyai

# Cargo
export CARGOPATH="$HOME/.cargo"

# Export PATH
export ISTIO_PATH="$HOME/workspace/istio-1.9.4/bin"
export HOME_PATHS="$HOME/.local/bin:$HOME/bin"
export PATH="$PATH:$ITSIO_PATH:$HOME_PATHS:/snap/bin:$GOROOT/bin:$GOPATH/bin:$CARGOPATH/bin"

# docker buildkit
export DOCKER_BUILDKIT=1

# nix path
#export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}
export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:$NIX_PATH}

# LUA path
#export LUA_PATH="$HOME/.config/nvim;;"
