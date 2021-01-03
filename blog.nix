{ src ? ./.,  pkgs ? (import <nixpkgs> {}), stdenv ? pkgs.stdenv, bundlerEnv ? pkgs.bundlerEnv, ruby ? pkgs.ruby, lib ? pkgs.lib }:

let 
  name = "terms-and-truth-conditions";
  env = bundlerEnv {
    inherit name;
    inherit ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
    gemConfig = pkgs.defaultGemConfig // {
      jekyll-whiteglass = attrs: {
        # The theme ships with a _config.yml, which we don't want. In particular it enables the old
        # pagination mehtod, which screws us up.
        postInstall = ''
          find $out -name '_config.yml' -delete
        '';
      };
    };
  };
in stdenv.mkDerivation {
  inherit name src;
  buildInputs = [ env ruby ];
  buildPhase =
    ''
      jekyll build --trace -d $out
    '';
  dontInstall = true;
  passthru = { inherit env; };
}
