{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  systemd.network = {
    netdevs = {
      "10-thesis-wg" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "thesis";
          MTUBytes = "1300";
        };
        # See also man systemd.netdev (also contains info on the permissions of the key files)
        wireguardConfig = {
          # Don't use a file from the Nix store as these are world readable.
          PrivateKeyFile = "/persist/etc/thesisWgPrivate";
        };
        wireguardPeers = [{
          PublicKey = "ntAF2JIWzNiuePHnIdJUxFElWilTOd9xBhXoRFz4SQs=";
          AllowedIPs = [ "10.72.73.0/16" ];
          Endpoint = "152.67.137.143:51823";
        }];
      };
    };
    networks.emberling = {
      matchConfig.Name = "emberling";
      address = [
        "10.174.1.2/32"
      ];
      DHCP = "no";
      networkConfig = {
        IPv6AcceptRA = false;
      };
    };
  };
}
