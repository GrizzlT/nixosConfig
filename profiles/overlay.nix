self: super: let
  myOverride = {
    packageOverrides = self': super': {
      primefac = self'.callPackage ./primefac.nix {};
      iphone-backup-decrypt = self'.callPackage ./iphone_backup_decrypt.nix {};

      control = self'.callPackage ./control_py.nix {};
    };
  };
in {
  rp = self.callPackage ./rp.nix {};
  whatsapp-chat-exporter = self.callPackage ./whatsapp-chat-exporter.nix {};
  python311 = super.python311.override myOverride;
  python312 = super.python312.override myOverride;
}
