{ stdenv, bundlerEnv, ruby, lib }:

let 
  name = "terms-and-truth-conditions";
  root = "blog";
  env = bundlerEnv {
    inherit name;
    inherit ruby;
    gemfile = ../Gemfile;
    lockfile = ../Gemfile.lock;
    gemset = ./gemset.nix;
  };
in stdenv.mkDerivation {
  inherit name;
  src = builtins.filterSource 
    (path: type: 
      let baseName = baseNameOf (toString path); 
      in !(
        # Filter out the build dir
        (type == "directory" && baseName == "build") ||
        # And the site dir
        (type == "directory" && baseName == "_site")
      )
    ) 
    ./..;
  buildInputs = [ env ruby ];
  buildPhase =
    ''
      jekyll build
    '';
  installPhase =
    ''
      mkdir -p $out/${root}
      cp -prvd _site/* $out/${root}/
    '';
}
