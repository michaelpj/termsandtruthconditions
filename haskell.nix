{ src, mkDerivation, base, lens, recursion-schemes, stdenv, markdown-unlit }:
mkDerivation {
  pname = "blog";
  version = "0.1.0.0";
  inherit src;
  libraryHaskellDepends = [ base lens recursion-schemes ];
  libraryToolDepends = [ markdown-unlit ];
  description = "Blog";
  license = stdenv.lib.licenses.mit;
}
