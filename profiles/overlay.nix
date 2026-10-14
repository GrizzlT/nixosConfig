inputs:
self: super: let
  myOverride = {
    packageOverrides = self': super': {
      primefac = self'.callPackage ./python/primefac.nix {};
      pyjls = self'.callPackage ./python/pyjls.nix {};
      datamol = self'.callPackage ./python/datamol.nix {};
      spicelib = self'.callPackage ./python/spicelib.nix {};
      iphone-backup-decrypt = self'.callPackage ./iphone_backup_decrypt.nix {};

      aiologic = self'.callPackage ./python/aiologic.nix {};
      ctf-attackapi = self'.callPackage ./python/ctf-attackapi.nix {};
      ecsc2026 = self'.callPackage ./python/ecsc2026.nix {};

      faultier = self'.callPackage ./python/faultier.nix {};

      control = self'.callPackage ./control_py.nix {};

      pwntools = super'.pwntools.overrideAttrs {
        src = self.fetchPypi {
          pname = "pwntools";
          version = "4.15.0";
          sha256 = "sha256-2ZqRcpjBynJBtRu6mtIhLyr0Qe9mSIBZskJlCOmip3Y=";
        };
      };
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

  inherit (inputs.pwndbg.packages.${self.system}) pwndbg pwndbg-lldb;
}
