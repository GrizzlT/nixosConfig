{ pkgs, ... }:
{
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [ virt-manager ];

  virtualisation.docker.enable = true;
  users.users.grizz.extraGroups = [ "docker" ];
}
