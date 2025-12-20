self: super: let
  myOverride = {
    packageOverrides = self': super': {
      primefac = self'.callPackage ./primefac.nix {};
      spicelib = self'.callPackage ./spicelib.nix {};
      iphone-backup-decrypt = self'.callPackage ./iphone_backup_decrypt.nix {};

      control = self'.callPackage ./control_py.nix {};
    };
  };
in {
  rp = self.callPackage ./rp.nix {};
  whatsapp-chat-exporter = self.callPackage ./whatsapp-chat-exporter.nix {};
  python311 = super.python311.override myOverride;
  python312 = super.python312.override myOverride;
  python313 = super.python313.override myOverride;
  python314 = super.python314.override myOverride;
  python315 = super.python315.override myOverride;
}
