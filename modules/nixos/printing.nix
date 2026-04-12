{ pkgs, ... }:
{
  services.printing = {
    enable = true;
    drivers = with pkgs; [ hplip ];
  };

  services.avahi = {
    enable = true;
    allowInterfaces = [ "bond0" ];
    nssmdns4 = true;
  };
  systemd.services.avahi-daemon.serviceConfig.NetworkNamespacePath = "/var/run/netns/physical";
}
