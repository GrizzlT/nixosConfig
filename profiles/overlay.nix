self: super: let
  myOverride = {
    packageOverrides = self': super': {
      primefac = self'.callPackage ./primefac.nix {};
    };
  };
in {
  rp = self.callPackage ./rp.nix {};
  python311 = super.python311.override myOverride;
}
