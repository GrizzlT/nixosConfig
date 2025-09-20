{
  mkProfile,
  haskellPackages,
}:
let
  hPkgs = haskellPackages;
in

mkProfile {
  name = "python";
  paths = [
    hPkgs.ghc
    hPkgs.cabal-fmt
    hPkgs.cabal-install
    hPkgs.haskell-language-server
  ];
}

