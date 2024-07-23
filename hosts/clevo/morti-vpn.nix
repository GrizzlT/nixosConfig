{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  systemd.network = {
    netdevs = {
      "10-morti" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "morti";
          MTUBytes = "1300";
        };
        wireguardConfig.PrivateKeyFile = "/persist/etc/mortiWgPrivate";
        wireguardPeers = [{
          wireguardPeerConfig = {
            PublicKey = "dVx1RzydmVbq8ou0hHczndyOVv8RhYUdndpz3HpaJm8=";
            PresharedKeyFile = "/persist/etc/mortiWgPresharedKey";
            AllowedIPs = [ "0.0.0.0/0" "::/0" ];
            Endpoint = "95.182.248.50:51820";
            PersistentKeepalive = 0;
          };
        }];
      };
    };
    networks.wgMorti = {
      matchConfig.Name = "morti";
      address = [
        "10.8.0.3/24"
      ];
      DHCP = "no";
    };
  };
}
