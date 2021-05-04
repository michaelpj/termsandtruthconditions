{ src, mkDerivation, base, lens, recursion-schemes, stdenv, lib, markdown-unlit }:
mkDerivation {
  pname = "blog";
  version = "0.1.0.0";
  inherit src;
  libraryHaskellDepends = [ base lens recursion-schemes ];
  libraryToolDepends = [ markdown-unlit ];
  description = "Blog";
  license = lib.licenses.mit;
}
