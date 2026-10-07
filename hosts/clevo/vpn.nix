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
  environment.systemPackages = [ pkgs.wiresneak ];

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
    management = {
      privateKey = "/persist/etc/managementWsPrivate";
      addresses = [ "fd7a:bada:1b1e:1::1/48" ];
      peers = {
        proxmox-management = {
          publicKey = "beeb2977349e51ed358436b559ff3acccb4fc33420271c48639af53c476b9a2d";
          allowedIPs = [ "fd7a:bada:1b1e:1::2/128" "fd7a:bada:1b1e:2:1::/80" ];
        };
      };
    };
  };
}
