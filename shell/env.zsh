# Ansible Path
export ANSIBLE_PATH="$HOME/workspace/lodestone"

# GOVC environment variables
export GOVC_USERNAME="jbartlett@denver.journey"
export GOVC_PASSWORD=""
export GOVC_URL="https://vcsa.denver.journey"
export GOVC_INSECURE="true"

# Androidsdk from Snap install 
#export ANDROID_SDK_ROOT=$HOME/snap/androidsdk/current/AndroidSDK

# GO ENV
export GOPATH="$HOME/.go"
export GOROOT="/usr/local/go"
export GOPRIVATE=github.com/journeyai

# Export PATH
HOME_PATHS="$HOME/.local/bin:/$HOME/bin"
export PATH="$PATH:$HOME_PATHS:/snap/bin:$GOROOT/bin:$GOPATH/bin"

# docker buildkit
export DOCKER_BUILDKIT=1
