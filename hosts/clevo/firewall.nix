{ pkgs, ... }:
let
  wanInterface = "wlp0s20f3";
  lanInterface = "enp46s0";
in
{
  networking.firewall = {
    enable = false;
  };

  networking.nftables = {
    enable = true;
    ruleset = ''
      table inet firewall {
        chain output {
          type filter hook output priority 100; policy accept;
        }

        chain incoming {
          type filter hook input priority 0; policy drop;

          # established/related connections
          ct state { established, related } accept

          # trusted interfaces
          iifname {
            "lo", "tailscale0"
          } counter accept

          # DHCP + DNS for VMs + LAN
          iifname { "vmbridge0", "${lanInterface}" } tcp dport 53 accept
          iifname { "vmbridge0", "${lanInterface}" } udp dport { 53, 67 } accept

          iifname ${wanInterface} udp dport 5353 accept

          # icmp
          icmp type echo-request accept
        }

        chain forward {
          type filter hook forward priority filter; policy drop;

          # Allow trusted network WAN access
          iifname {
            "vmbridge0", "${lanInterface}"
          } oifname {
            "${wanInterface}",
          } counter accept comment "Allow trusted LAN to WAN"

          # Allow established WAN to return
          iifname {
            "${wanInterface}",
          } oifname {
            "vmbridge0", "${lanInterface}"
          } ct state { established,related } counter accept comment "Allow established back to LANs"
        }
      }

      table ip nat {
        chain prerouting {
          type nat hook prerouting priority filter; policy accept;
        }

        # Setup NAT masquerading on the wan interface
        chain postrouting {
          type nat hook postrouting priority filter; policy accept;
          oifname "${wanInterface}" masquerade
        }
      }

      table ip6 firewall {
        chain incoming {
          type filter hook input priority 0; policy drop;
          # established/related connections
          ct state { established, related, } accept
          # invalid connections
          ct state invalid drop
          # loopback interface
          iifname lo accept
          # icmp
          # routers may also want: mld-listener-query, nd-router-solicit
          icmpv6 type {echo-request,nd-neighbor-solicit} accept
        }
      }
    '';
  };
}
