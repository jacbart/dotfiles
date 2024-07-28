ARCH=arm64
VERSION=v0.8.2
curl -LO https://github.com/docker/docker-credential-helpers/releases/download/${VERSION}/docker-credential-osxkeychain-${VERSION}.darwin-${ARCH}
mkdir -p ~/.docker/cli-plugins
mv docker-credential-osxkeychain-${VERSION}.darwin-${ARCH} ~/bin/docker-credential-osxkeychain
chmod +x ~/bin/docker-credential-osxkeychain
