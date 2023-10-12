{ pkgs, ... }:
{
  services.tailscale = {
    enable = true;
    package = pkgs.unstable.tailscale;
  };

  systemd.services.tailscaled.after = [ "network-online.target" "systemd-resolved.service" ];
}
