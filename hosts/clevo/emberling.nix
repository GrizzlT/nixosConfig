{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  systemd.network = {
    netdevs = {
      "10-emberling-wg" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "emberling";
          MTUBytes = "1300";
        };
        # See also man systemd.netdev (also contains info on the permissions of the key files)
        wireguardConfig = {
          # Don't use a file from the Nix store as these are world readable.
          PrivateKeyFile = "/persist/etc/emberlingWgPrivate";
        };
        wireguardPeers = [{
          PublicKey = "/x6enB4qXz/lLToqudIf1advT/9IIwo0eU+nuUtHayY=";
          AllowedIPs = [ "10.174.0.0/16" ];
          Endpoint = "152.67.137.143:51822";
        }];
      };
    };
    networks.emberling = {
      matchConfig.Name = "emberling";
      address = [
        "10.174.1.3/16"
      ];
      DHCP = "no";
      networkConfig = {
        IPv6AcceptRA = false;
      };
    };
  };
}
