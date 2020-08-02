{ src ? ./.,  pkgs ? (import <nixpkgs> {}), stdenv ? pkgs.stdenv, bundlerEnv ? pkgs.bundlerEnv, ruby ? pkgs.ruby, lib ? pkgs.lib }:

let 
  name = "terms-and-truth-conditions";
  env = bundlerEnv {
    inherit name;
    inherit ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
in stdenv.mkDerivation {
  inherit name src;
  buildInputs = [ env ruby ];
  buildPhase =
    ''
      jekyll build -d $out
    '';
  dontInstall = true;
  passthru = { inherit env; };
}
