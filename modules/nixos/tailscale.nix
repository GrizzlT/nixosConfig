{ ... }:
{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  systemd.services.tailscaled.after = [ "network.target" "systemd-resolved.service" ];
}
