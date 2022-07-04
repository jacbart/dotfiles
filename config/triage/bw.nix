with (import <nixpkgs> {});
mkShell {
  buildInputs = [
    bitwarden-cli
    jless
  ];
  shellHook = ''
    bw login --apikey
    export BW_SESSION=$(bw unlock --passwordenv BW_PASS --raw)
  '';
}

