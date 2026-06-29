{ self, nixpkgs, ... }@inputs:
let
  profiles = import "${self}/profiles" inputs;

  forSystem = system: let
    nixpkgs-unstable = import inputs.unstable {
      inherit system;
      overlays = [
        self.overlays.default
      ] ++ profiles.overlays;
    };
  in import nixpkgs {
    inherit system;
    overlays = [
      self.overlays.default
      (self: super: {
        unstable = self.lib.makeScope self.newScope (self0: {
          inherit (nixpkgs-unstable) typst tinymist binwalk harper saw-tools yosys typescript-language-server;
          unstable-python311 = nixpkgs-unstable.python311;
        });
      })
    ] ++ profiles.overlays;
    config.allowUnfreePredicate = pkg:
      builtins.elem (nixpkgs.lib.getName pkg) [
        "ngrok"
        "gdlauncher-carbon"
        "nrf-command-line-tools"
        "segger-jlink"
        "nrfconnect"
        "nrf5-sdk"
      ];
    config.permittedInsecurePackages = [
      "segger-jlink-qt4-874"
    ];
    config.segger-jlink.acceptLicense = true;
  };
in
nixpkgs.lib.recursiveUpdate (nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" ] (system: let pkgs = forSystem system; in {
  inherit (pkgs) grizz-disk-setup grizz-zfs-diff;
})) (nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" "x86_64-darwin" ] (system: let pkgs = forSystem system; in {
  inherit (pkgs) emoji-fzf porsmo awatcher paperage tackler neovim xmcl hledger-lsp cfait;
} // (profiles.profiles pkgs)))
