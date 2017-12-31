let
  pkgs = import <nixpkgs> {};
in
  { stdenv ? pkgs.stdenv }:

  stdenv.mkDerivation {
    name = "pythonReq";
    buildInputs = [
      pkgs.python2
      pkgs.python2Packages.requests
      pkgs.python2Packages.beautifulsoup4
      pkgs.python2Packages.markdown
      pkgs.python2Packages.pygments
      pkgs.python2Packages.pycrypto
    ];
  }
