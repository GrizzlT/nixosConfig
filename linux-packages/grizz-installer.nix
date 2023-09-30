{ self, pkgs, nixos-generators, ...}:
nixos-generators.nixosGenerate {
  system = pkgs.system;
  format = "iso";
  specialArgs = let custom-pkgs = self.packages.${pkgs.system}; in
  with custom-pkgs; {
    inherit grizz-disk-setup;
    inherit grizz-zfs-diff;
  };
  modules = [
    ({ config, pkgs, lib, modulesPath, ... }@inputs:
    {
      imports = [
        (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
        # Provide an initial copy of the NixOS channel so that the user
        # doesn't need to run "nix-channel --update" first.
        (modulesPath +  "/installer/cd-dvd/channel.nix")
        ../modules/grizz-keyboard.nix
      ];

      environment.systemPackages = [
        pkgs.vim
        pkgs.wget
        pkgs.curl
        pkgs.git
        pkgs.zfs
        inputs.grizz-disk-setup
        inputs.grizz-zfs-diff
      ];

      networking.networkmanager.enable = true;
      networking.wireless.enable = false;

      isoImage.squashfsCompression = "gzip -Xcompression-level 1";
    })
  ];
}

