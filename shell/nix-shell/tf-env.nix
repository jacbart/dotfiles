with (import <nixpkgs> {});
mkShell {
  buildInputs = [
    terraform
    ansible
    age
    curl
    dig
    jless
    bash
  ];
  shellHook = ''
    if [ -f "env" ]; then
      eval $(cat env)
    fi
  '';
}