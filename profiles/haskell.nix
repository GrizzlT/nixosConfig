{
  mkProfile,
  haskellPackages,
}:
let
  hPkgs = haskellPackages;
in

mkProfile {
  name = "haskell";
  paths = [
    hPkgs.ghc
    hPkgs.cabal-fmt
    hPkgs.cabal-install
    hPkgs.haskell-language-server
  ];
}

