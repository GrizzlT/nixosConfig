{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  systemd.network = {
    netdevs = {
      "10-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
          MTUBytes = "1300";
        };
        # See also man systemd.netdev (also contains info on the permissions of the key files)
        wireguardConfig = {
          # Don't use a file from the Nix store as these are world readable.
          PrivateKeyFile = "/persist/etc/ecscWg0private";
          ListenPort = 9918;
        };
        wireguardPeers = [{
          wireguardPeerConfig = {
            PublicKey = "Phkd6kTadSdb/rllZRMRJkoJeQiZsyxh/l7Hpcwbf24=";
            AllowedIPs = [ "172.23.0.0/24" "172.16.0.0/16"];
            Endpoint = "129.241.150.48:51820";
            PersistentKeepalive = 25;
          };
        }];
      };
    };
    networks.wg0 = {
      matchConfig.Name = "wg0";
      address = [
        "172.23.0.8/24"
      ];
      routes = [
        { routeConfig = {
          Gateway = "172.23.0.1";
          Destination = "172.16.0.0/16";
        }; }
      ];
      DHCP = "no";
      networkConfig = {
        IPv6AcceptRA = false;
      };
    };
  };
}
