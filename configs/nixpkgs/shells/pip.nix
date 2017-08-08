let
  pkgs = import <nixpkgs> {};
in
  { stdenv ? pkgs.stdenv }:

  stdenv.mkDerivation {
    name = "pythonReq";
    buildInputs = [
      pkgs.python2
      pkgs.python2Packages.pip
    ];
  }
