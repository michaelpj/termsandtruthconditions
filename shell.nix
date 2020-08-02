{ pkgs ? import <nixpkgs> {} }:
let
  inherit (import ./default.nix { inherit pkgs; }) blog haskell;
in
pkgs.mkShell {
  buildInputs = [ pkgs.ghcid ];
  inputsFrom = [ blog haskell.env ];
}
