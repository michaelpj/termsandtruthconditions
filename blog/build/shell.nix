{ nixpkgs ? import <nixpkgs> {} }:
with nixpkgs; callPackage ./default.nix {}
