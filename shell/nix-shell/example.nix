with (import <nixpkgs> {});
mkShell {
  buildInputs = [
    neovim
    zsh
  ];
  shellHook = ''
    alias la="ls -la"
    alias vim="nvim"
    export FOO=bar
  '';
}
