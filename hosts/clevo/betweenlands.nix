{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  systemd.network = {
    netdevs = {
      "10-between" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "between";
          MTUBytes = "1300";
        };
        # See also man systemd.netdev (also contains info on the permissions of the key files)
        wireguardConfig = {
          # Don't use a file from the Nix store as these are world readable.
          PrivateKeyFile = "/persist/etc/betweenWgPrivate";
          ListenPort = 9918;
        };
        wireguardPeers = [{
          wireguardPeerConfig = {
            PublicKey = "fdCi0UOnCYvq5oEJU3+UJ8oUiFtpaC7/CzUSomcdiRY=";
            AllowedIPs = [ "10.13.0.0/24" ];
            Endpoint = "130.61.145.107:51820";
            PersistentKeepalive = 25;
          };
        }];
      };
    };
    networks.wg0 = {
      matchConfig.Name = "between";
      address = [
        "10.13.0.3/24"
      ];
      # routes = [
      #   { routeConfig = {
      #     Gateway = "172.23.0.1";
      #     Destination = "172.16.0.0/16";
      #   }; }
      # ];
      DHCP = "no";
      networkConfig = {
        IPv6AcceptRA = false;
      };
    };
  };
}
