with import <nixpkgs> {};

mkShell {
  buildInputs = [ qemu ];

  shellHook = ''
    export NIX_PATH=nixpkgs=https://github.com/NixOS/nixpkgs-channels/archive/nixos-18.09.tar.gz
  '';
}
