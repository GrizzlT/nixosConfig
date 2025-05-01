self: super: let
  myOverride = {
    packageOverrides = self': super': {
      primefac = self'.callPackage ./primefac.nix {};
      iphone-backup-decrypt = self'.callPackage ./iphone_backup_decrypt.nix {};

      control = self'.callPackage ./control_py.nix {};
      angr = super'.angr.override {
        unicorn = super'.unicorn.overrideAttrs (prevAttrs: {
          version = "2.0.1";
          src = self.fetchFromGitHub {
            owner = "unicorn-engine";
            repo = "unicorn";
            rev = "e9c1c17f6df8f8f5da85ee80ad527452db5870ce";
            hash = "sha256-Jz5C35rwnDz0CXcfcvWjkwScGNQO1uijF7JrtZhM7mI=";
          };
        });
      };
      unicorn = super'.unicorn.overrideAttrs (prevAttrs: {
        version = "2.0.1";
        src = self.fetchFromGitHub {
          owner = "unicorn-engine";
          repo = "unicorn";
          rev = "e9c1c17f6df8f8f5da85ee80ad527452db5870ce";
          hash = "sha256-Jz5C35rwnDz0CXcfcvWjkwScGNQO1uijF7JrtZhM7mI=";
        };
      });
    };
  };
in {
  rp = self.callPackage ./rp.nix {};
  whatsapp-chat-exporter = self.callPackage ./whatsapp-chat-exporter.nix {};
  python311 = super.python311.override myOverride;
  python312 = super.python312.override myOverride;
}
