{ pkgs, lib, ... }:

let
  networks = {
    thesis = {
      PrivateKeyFile = "/persist/etc/thesisWgPrivate";
      addresses = [ "10.72.73.2/24" ];
      peers = {
        relay = {
          PublicKey = "ntAF2JIWzNiuePHnIdJUxFElWilTOd9xBhXoRFz4SQs=";
          AllowedIPs = [ "10.72.73.0/24" ];
          Endpoint = "152.67.137.143:51823";
        };
      };
    };
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
}
