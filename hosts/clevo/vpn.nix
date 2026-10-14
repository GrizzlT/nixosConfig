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
    ecsc2026 = {
      PrivateKeyFile = "/persist/etc/ecsc2026WgPrivate";
      addresses = [ "10.60.4.24/16" ];
      peers = {
        gateway = {
          PublicKey = "ewYXaeVwKEFmYGx2cfjkcEBfvR9kCT7iUPaIBkpEpjU=";
          AllowedIPs = [ "10.60.0.0/16" ];
          Endpoint = "213.239.140.237:31504";
          PersistentKeepalive = 20;
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
      + (lib.optionalString (peer ? PersistentKeepalive) " persistent-keepalive ${toString peer.PersistentKeepalive}")
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
      bootstrapDns = [ "https://dns.quad9.net@9.9.9.9/dns-query" "https://dns.quad9.net@149.112.112.112/dns-query" "https://cloudflare-dns.com@1.1.1.1/dns-query" "https://cloudflare-dns.com@1.0.0.1/dns-query" ];
      peers = {
        proxmox-management = {
          publicKey = "beeb2977349e51ed358436b559ff3acccb4fc33420271c48639af53c476b9a2d";
          allowedIPs = [ "fd7a:bada:1b1e:1::2/128" "fd7a:bada:1b1e:2:1::/80" ];
        };
        giada = {
          publicKey = "558857b7be8bb243b9e0744f64febe328b826d871692c88f5d9e993cff0b7db6";
          allowedIPs = [ "fd7a:bada:1b1e:2:ffff::2/128" ];
        };
        xub = {
          publicKey = "982e972fedb6b2b78883c07415b146a0bda755a681323999aaac3edf2cd55563";
          allowedIPs = [ "fd7a:bada:1b1e:2:ffff::3/128" "fd7a:bada:1b1e:1::3/128" ];
        };
        curly = {
          publicKey = "37aa0f82532a13ab4a68eca8a0dc7c459b7d6d681ce96d197eee181f603419b0";
          allowedIPs = [ "fd7a:bada:1b1e:2:ffff::4/128" ];
        };
     };
    };
  };
}
