{ pkgs ? import <nixpkgs> {} }:
let src = builtins.filterSource 
    (path: type: 
      let baseName = baseNameOf (toString path); 
      in !(
        # Filter out the site dir
        (type == "directory" && baseName == "_site")
        # And dist-newstyle
        ||
        (type == "directory" && baseName == "dist-newstyle")
      )
    ) 
    ./.;
in {
  blog = pkgs.callPackage ./blog.nix { inherit src; };
  haskell = pkgs.haskellPackages.callPackage ./haskell.nix { inherit src; };
}
