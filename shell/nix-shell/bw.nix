with (import <nixpkgs> {});
mkShell {
  buildInputs = [
    bitwarden-cli
    fzf
    jless
    jq
  ];
  shellHook = ''
    export BW_CLIENTID=""
    export BW_CLIENTSECRET=""
    export BW_SCOPE="api"
    export BW_PASS=
    export BW_SESSION=$(bw unlock --passwordenv BW_PASS --raw)
    unset BW_PASS
  '';
}
