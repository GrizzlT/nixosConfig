{ pkgs, ... }:
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
          PublicKey = "FN9RP0sx6ncqBCUPoSoeGcmaV40qD3VsvjnJ+klsSHA=";
          AllowedIPs = [ "172.23.0.0/24" ];
          Endpoint = "141.147.65.85:51820";
          PersistentKeepalive = 25;
        }];
      };
    };
    networks.wg0 = {
      matchConfig.Name = "wg0";
      address = [
        "172.23.0.102/24"
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
