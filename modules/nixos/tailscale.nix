{ ... }:
{
  services.tailscale = {
    enable = true;
  };

  systemd.services.tailscaled.after = [ "network.target" "systemd-resolved.service" ];
}
