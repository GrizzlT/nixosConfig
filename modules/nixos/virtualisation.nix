{ pkgs, config, ... }:
let
  user = config.grizz.settings.user;
in
{
  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [ "virbr0" "vmbridge0" ];
  };
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [ virt-manager ];

  virtualisation.docker.enable = true;
  users.users.${user}.extraGroups = [ "docker" "libvirtd" ];
}
