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

          # established/related connections
          ct state { established, related } accept
          ct state invalid drop
          iifname lo accept

          iifname tailscale0 counter accept

          # DHCP + DNS for VMs + LAN
          iifname { "vmbridge0", "ethvlan" } tcp dport 53 accept # DNS
          iifname { "vmbridge0", "ethvlan" } udp dport { 53, 67 } accept # DNS + DHCP

          # iifname { vmbridge0, ethvlan, bond0 } udp dport 5353 accept # mDNS

          tcp dport { 8080, 8081, 8082 } accept
          tcp dport 22000 accept comment "syncthing"
          udp dport { 21027, 22000 } accept comment "syncthing"

          # icmp
          icmp type echo-request accept
        }

        chain forward {
          type filter hook forward priority filter; policy drop;

          # Allow docker networks
          ip saddr 172.16.0.0/12 oifname mullvad accept
          ip saddr 172.16.0.0/12 ip daddr 172.16.0.0/12 accept
          # allow tailscale on docker
          iifname tailscale0 ip daddr 172.16.0.0/12 accept
          # allow established traffic
          ip saddr 172.16.0.0/12 ct state { established, related } counter accept
          ip daddr 172.16.0.0/12 ct state { established, related } counter accept

          # Allow trusted network WAN access
          # iifname { "vmbridge0", ethvlan } oifname { bond0, } counter accept comment "Allow trusted LAN to WAN"

          # Allow established WAN to return
          # iifname { bond0 } oifname { "vmbridge0", ethvlan } ct state { established,related } counter accept comment "Allow established back to LANs"
        }

        chain prerouting {
          type nat hook prerouting priority filter; policy accept;
        }

        # Setup NAT masquerading on the wan interface
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

          ip6 nexthdr udp udp dport { 546, 547 } accept

          # ICMPv6 essential messages
          ip6 nexthdr icmpv6 icmpv6 type {
            133, # Router Solicitation
            134, # Router Advertisement
            135, # Neighbor Solicitation
            136, # Neighbor Advertisement
            128, # Echo Request (ping)
            129  # Echo Reply (pong)
          } accept

          tcp dport 8080 accept
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

                  tcp dport { 8080, 8081, 8082 }

                  icmp type echo-request accept
                }

                chain forward {
                  type filter hook forward priority filter; policy drop;

                  iifname lan-physical oifname bond0 counter accept comment "Allow access to LAN"
                  iifname bond0 oifname lan-physical ct state { established, related } counter accept comment "Allow access to LAN"
                }

                chain prerouting {
                  type nat hook prerouting priority filter; policy accept;
                }

                chain postrouting {
                  type nat hook postrouting priority filter; policy accept;
                  oifname bond0 masquerade
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
