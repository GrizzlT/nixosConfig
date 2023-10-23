{ pkgs, ... }:
{
  services.tailscale = {
    enable = true;
    package = pkgs.unstable.tailscale;
  };

  systemd.services.tailscaled.after = [ "network.target" "systemd-resolved.service" ];
}
