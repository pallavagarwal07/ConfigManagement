let
  pkgs = import <nixpkgs> {};
in
  { stdenv ? pkgs.stdenv }:

  stdenv.mkDerivation {
    name = "pythonReq";
    buildInputs = [
      pkgs.python3
      pkgs.python3Packages.requests
      pkgs.python3Packages.beautifulsoup4
      pkgs.python3Packages.markdown
      pkgs.python3Packages.pygments
    ];
  }
