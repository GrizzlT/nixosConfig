{ config, pkgs, lib, ... }:
{
  networking.firewall = {
    enable = false;
  };

  networking.nftables = {
    enable = true;
    ruleset = ''
      table ip virtual-ip {
        chain output {
          type filter hook output priority 100; policy accept;
        }

        chain incoming {
          type filter hook input priority 0; policy drop;

          ct state { established, related } accept
          ct state invalid drop
          iifname lo accept

          iifname tailscale0 counter accept

          iifname { vmbridge0, lan-virtual } tcp dport 53 accept # DNS
          iifname { vmbridge0, lan-virtual } udp dport 53 accept # DNS
          iifname vmbridge0 udp dport 67 accept # DNS + DHCP

          tcp dport { 8080, 8081, 8082 } accept

          tcp dport 22000 accept comment "syncthing"
          udp dport { 21027, 22000 } accept comment "syncthing"

          icmp type echo-request accept
        }

        chain forward {
          type filter hook forward priority filter; policy drop;

          ip saddr 172.16.0.0/12 oifname mullvad accept comment "docker to WAN"
          ip saddr 172.16.0.0/12 ip daddr 172.16.0.0/12 accept comment "docker internal forward"
          iifname tailscale0 ip daddr 172.16.0.0/12 accept comment "tailscale0 to docker"
          ip saddr 172.16.0.0/12 ct state { established, related } counter accept comment "docker established ->"
          ip daddr 172.16.0.0/12 ct state { established, related } counter accept comment "-> docker established"

          iifname vmbridge0 oifname mullvad counter accept comment "VM to WAN"
          iifname mullvad oifname vmbridge0 ct state { established, related } counter accept comment "WAN reply to VM"
        }

        chain prerouting {
          type nat hook prerouting priority filter; policy accept;
        }

        chain postrouting {
          type nat hook postrouting priority filter; policy accept;
          oifname { mullvad } masquerade
        }
      }

      table ip6 virtual-ip6 {
        chain incoming {
          type filter hook input priority 0; policy drop;

          ct state { established, related, } accept
          ct state invalid drop
          iifname lo accept

          udp dport { 546, 547 } accept

          # ICMPv6 essential messages
          icmpv6 type {
            133, # Router Solicitation
            134, # Router Advertisement
            135, # Neighbor Solicitation
            136, # Neighbor Advertisement
            137, # Redirect
            128, # Echo Request (ping)
            129  # Echo Reply (pong)
          } accept

          tcp dport 8080 accept

          iifname tailscale0 counter accept
        }
      }
    '';
  };

  systemd.services.nftables-physical = {
    description = "nftables firewall";
    after = [ "sysinit.target" ];
    before = [
      "shutdown.target"
    ];
    conflicts = [ "shutdown.target" ];
    wants = [
      "network-pre.target"
      "sysinit.target"
    ];
    wantedBy = [ "multi-user.target" ];
    reloadIfChanged = true;
    serviceConfig =
        let
          deletionsScript = pkgs.writeScript "nftables-deletions" ''
            #! ${pkgs.nftables}/bin/nft -f
            flush ruleset
          '';
          deletionsScriptVar = "/var/lib/nftables/deletions.nft";
          ensureDeletions = pkgs.writeShellScript "nftables-ensure-deletions" ''
            touch ${deletionsScriptVar}
            chmod +x ${deletionsScriptVar}
          '';
          saveDeletionsScript = pkgs.writeShellScript "nftables-save-deletions" ''
            cp ${deletionsScript} ${deletionsScriptVar}
          '';
          cleanupDeletionsScript = pkgs.writeShellScript "nftables-cleanup-deletions" ''
            rm ${deletionsScriptVar}
          '';
          rulesScript = pkgs.writeTextFile {
            name = "nftables-rules";
            executable = true;
            text = ''
              #! ${pkgs.nftables}/bin/nft -f
              # previous deletions, if any
              include "${deletionsScriptVar}"
              # current deletions
              include "${deletionsScript}"


              table ip physical-ip {
                chain output {
                  type filter hook output priority 100; policy accept;
                }

                chain incoming {
                  type filter hook input priority 0; policy drop;

                  ct state { established, related } accept
                  ct state invalid drop
                  iifname lo accept

                  iifname bond0 udp dport 5353 accept comment "mDNS"
                  iifname ethvlan udp dport 67 accept comment "DNS + DHCP"

                  tcp dport { 8080, 8081, 8082 }

                  icmp type echo-request accept
                }

                chain forward {
                  type filter hook forward priority filter; policy drop;

                  iifname lan-physical oifname bond0 counter accept comment "Allow access to LAN"
                  iifname bond0 oifname lan-physical ct state { established, related } counter accept comment "Allow access to LAN"

                  udp dport 53 oifname lan-physical counter accept comment "forward to inner firewall"
                  tcp dport { 8080, 8081, 8082 } oifname lan-physical counter accept comment "forward to inner firewall"
                  tcp dport 22000 oifname lan-physical counter accept comment "forward to inner firewall"
                  udp dport { 21027, 22000 } oifname lan-physical counter accept comment "forward to inner firewall"
                }

                chain prerouting {
                  type nat hook prerouting priority filter; policy accept;

                  iifname ethvlan udp dport 53 dnat to 198.18.13.13:53 comment "DNS passthrough"

                  tcp dport { 8080, 8081, 8082 } dnat to 198.18.13.13 comment "port forwarding"
                  tcp dport 22000 dnat to 198.18.13.13 comment "syncthing"
                  udp dport { 21027, 22000 } dnat to 198.18.13.13 comment "syncthing"
                }

                chain postrouting {
                  type nat hook postrouting priority filter; policy accept;
                  oifname bond0 masquerade
                  oifname ethvlan masquerade
                  oifname lan-physical masquerade
                }
              }

              table ip6 physical-ip6 {
                chain incoming {
                  type filter hook input priority 0; policy drop;

                  ct state { established, related } accept
                  ct state invalid drop
                  iifname lo accept

                  iifname bond0 udp dport 5353 accept comment "mDNS"

                  ip6 nexthdr udp udp dport { 546, 547 } accept comment "dhcpv6"

                  ip6 nexthdr icmpv6 icmpv6 type {
                    133, # Router Solicitation
                    134, # Router Advertisement
                    135, # Neighbor Solicitation
                    136, # Neighbor Advertisement
                    137, # Redirect
                    128, # Echo Request (ping)
                    129  # Echo Reply (pong)
                  } accept

                  tcp dport 8080 accept
                }
              }

            '';
            checkPhase = ''
              cp $out ruleset.conf
              sed 's|include "${deletionsScriptVar}"||' -i ruleset.conf
              export NIX_REDIRECTS=${
                lib.escapeShellArg (
                  lib.concatStringsSep ":" (lib.mapAttrsToList (n: v: "${n}=${v}") config.networking.nftables.checkRulesetRedirects)
                )
              }
              LD_PRELOAD="${pkgs.buildPackages.libredirect}/lib/libredirect.so ${pkgs.buildPackages.lklWithFirewall.lib}/lib/liblkl-hijack.so" \
                ${pkgs.buildPackages.nftables}/bin/nft --check --file ruleset.conf
            '';
          };
        in
        {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = [
            ensureDeletions
            rulesScript
          ];
          ExecStartPost = saveDeletionsScript;
          ExecReload = [
            ensureDeletions
            rulesScript
            saveDeletionsScript
          ];
          ExecStop = [
            deletionsScriptVar
            cleanupDeletionsScript
          ];
          StateDirectory = "nftables-physical";
          NetworkNamespacePath = "/var/run/netns/physical";
        };
      unitConfig.DefaultDependencies = false;
  };
}
