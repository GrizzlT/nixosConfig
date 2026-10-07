{ pkgs, lib, ... }:

let
  networks = {
    emberling = {
      PrivateKeyFile = "/persist/etc/emberlingWgPrivate";
      addresses = [ "10.174.1.3/16" ];
      peers = {
        relay = {
          PublicKey = "/x6enB4qXz/lLToqudIf1advT/9IIwo0eU+nuUtHayY=";
          AllowedIPs = [ "10.174.0.0/16" ];
          Endpoint = "152.67.137.143:51822";
        };
      };
    };
  };
in
{
  systemd.services = lib.mapAttrs' (name: value: let
    interfaceName = value.interface or name;
    peerArgs = lib.concatMapAttrsStringSep " " (_: peer:
      "peer ${peer.PublicKey}"
      + (lib.optionalString (peer ? Endpoint) " endpoint ${peer.Endpoint}")
      + (lib.optionalString (peer ? PersistentKeepalive) " persistent-keepalive ${peer.PersistentKeepalive}")
      + (lib.optionalString (peer ? AllowedIPs) " allowed-ips ${lib.concatStringsSep "," peer.AllowedIPs}")
      ) value.peers or {};

    ipAddrCmds = lib.concatMapStringsSep "\n" (addr: "ip addr add ${addr} dev ${interfaceName}") value.addresses or [];
  in {
    name = "${name}-wg-tunnel";
    value = {
      after = [ "setup-public-network.service" ];
      requires = [ "setup-public-network.service" ];
      wants = [ "setup-public-network.service" ];

      path = [ pkgs.iproute2 pkgs.wireguard-tools ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "setup-${name}-wg-tunnel" /* bash */ ''
          ip -n physical link add dev ${interfaceName} type wireguard
          ip -n physical link set ${interfaceName} netns 1
          ip link set ${interfaceName} up

          ip link set ${interfaceName} mtu ${value.mtu or "1420"}
          wg set ${interfaceName} private-key ${value.PrivateKeyFile} ${peerArgs}
          ${ipAddrCmds}
        '';
        ExecStop = pkgs.writeShellScript "shutdown-${name}-wg-tunnel" /* bash */ ''
          ip link del ${interfaceName}
        '';
      };
    } // lib.optionalAttrs (value.enableAtStart or true) {
      wantedBy = [ "multi-user.target" ];
    };
  }) networks;

  services.wiresneakd.networks = {
    guinea = {
      privateKey = "/persist/etc/guineaWsPrivate";
      addresses = [ "10.175.13.1/24" ];
      peers = {
        dashboard = {
          publicKey = "3a730bb85782ba73f7911c4dbeb8f552b753f111148dd48423318dd98e2a795c";
          allowedIPs = [ "10.175.13.2/32" ];
        };
      };
    };
  };
}
