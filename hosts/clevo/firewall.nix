{ ... }:
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
            "lo", "tailscale0",
          } counter accept

          # DHCP + DNS for VMs + LAN
          iifname { "vmbridge0", "ethvlan" } tcp dport 53 accept # DNS
          iifname { "vmbridge0", "ethvlan" } udp dport { 53, 67 } accept # DNS + DHCP

          iifname { vmbridge0, ehtvlan, bond0 } udp dport 5353 accept # mDNS

          iifname { between } tcp dport 8080 accept

          # icmp
          icmp type echo-request accept
        }

        chain forward {
          type filter hook forward priority filter; policy drop;

          # Allow docker networks
          ip saddr 172.16.0.0/12 oifname bond0 accept
          ip saddr 172.16.0.0/12 ip daddr 172.16.0.0/12 accept
          iifname tailscale0 ip daddr 172.16.0.0/12 accept
          ip saddr 172.16.0.0/12 ct state { established, related } counter accept
          ip daddr 172.16.0.0/12 ct state { established, related } counter accept

          # Allow trusted network WAN access
          iifname {
            "vmbridge0", ethvlan
          } oifname {
            bond0,
          } counter accept comment "Allow trusted LAN to WAN"

          # Allow established WAN to return
          iifname {
            bond0
          } oifname {
            "vmbridge0", ethvlan
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
          oifname { bond0 } masquerade
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
