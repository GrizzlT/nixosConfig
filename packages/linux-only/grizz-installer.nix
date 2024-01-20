{ pkgs, nixos-generators, grizzScripts, selfNixos, ...}:
nixos-generators.nixosGenerate {
  system = pkgs.system;
  format = "iso";
  specialArgs = grizzScripts // { inherit selfNixos; };
  modules = [
    ({ config, pkgs, lib, modulesPath, ... }@inputs:
    {
      imports = [
        (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
        # Provide an initial copy of the NixOS channel so that the user
        # doesn't need to run "nix-channel --update" first.
        (modulesPath +  "/installer/cd-dvd/channel.nix")
        selfNixos.keyboardConfig
        selfNixos.nixConfig
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

