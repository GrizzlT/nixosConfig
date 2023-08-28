{ pkgs, ... }:
{
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [ virt-manager ];

  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "zfs";
  users.users.grizz.extraGroups = [ "docker" ];
}
