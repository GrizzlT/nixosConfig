{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  systemd.network = {
    netdevs = {
      "10-solo-wg" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "solo";
          MTUBytes = "1300";
        };
        wireguardConfig = {
          PrivateKeyFile = "/persist/etc/soloWgPrivate";
          ListenPort = 9917;
        };
        wireguardPeers = [{
          wireguardPeerConfig = {
            PublicKey = "UMWx2wJm7HXgi4dmmoR1eBKjQD6uA64rKbyrU2TlcnQ=";
            AllowedIPs = [ "10.123.13.0/24" ];
            Endpoint = "130.61.145.107:51813";
            PersistentKeepalive = 25;
          };
        }];
      };
    };
    networks.wg0 = {
      matchConfig.Name = "solo";
      address = [
        "10.123.13.2/24"
      ];
      DHCP = "no";
      networkConfig = {
        IPv6AcceptRA = false;
      };
    };
  };
}
