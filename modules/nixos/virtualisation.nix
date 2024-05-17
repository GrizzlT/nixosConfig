{ pkgs, ... }:
{
  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [ "virbr0" "vmbridge0" ];
  };
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [ virt-manager ];

  virtualisation.docker.enable = true;
  users.users.grizz.extraGroups = [ "docker" "libvirtd" ];
}
