{ pkgs, lib, config, ... }:
let
  public-ethernet = "enp46s0";
  public-wifi = "wlan0";
in
{
  environment.systemPackages = with pkgs; [
    dnsmasq
    wpa_supplicant_gui
    ndisc6
    dhcpcd
    iproute2
    iwd
    iw

    wireguard-tools
    mullvad-vpn
  ];

  networking = {
    networkmanager.enable = lib.mkForce false;

    hostId = "13eb44cc";

    wireless.iwd = {
      enable = true;
      settings = {
        General = {
          AddressRandomization = "disabled";
        };
        Network = {
          NameResolvingService = "resolvconf";
        };
      };
    };
  };

  networking.dhcpcd = {
    enable = true;
    allowInterfaces = [ "bond0" ];
    extraConfig = ''
      nohook resolv.conf
      noipv4ll
    '';
  };

  systemd.services.setup-public-network = {
    before = [ "dhcpcd.service" "iwd.service" ];
    after = [ "dbus.service" "nftables.service" ];
    wants = [ "dbus.service" "nftables.service" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.openresolv pkgs.nftables ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "setup-public-network" /* bash */ ''
        ${pkgs.iproute2}/bin/ip link add ethslave link ${public-ethernet} type macvlan mode bridge
        ${pkgs.iproute2}/bin/ip link add bond0 type bond miimon 100 mode active-backup fail_over_mac none primary_reselect always primary ethslave
        ${pkgs.iproute2}/bin/ip link set ethslave master bond0
        ${pkgs.iproute2}/bin/ip link set ${public-wifi} master bond0

        ${pkgs.iproute2}/bin/ip link set ${public-ethernet} up
        ${pkgs.iproute2}/bin/ip link set ${public-wifi} up

        ${pkgs.wireguard-tools}/bin/wg-quick up /home/grizz/DATA/.mullvad/mullvad.conf
      '';
      ExecStop = pkgs.writeShellScript "shutdown-public-network" /* bash */ ''
        ${pkgs.wireguard-tools}/bin/wg-quick down /home/grizz/DATA/.mullvad/mullvad.conf
      '';
    };
  };
  systemd.services.force-iwd-mac = {
    after = [ "iwd.service" "setup-public-network.service" ];
    wantedBy = [ "iwd.service" "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "reset-iwd-wlan-master" /* bash */ ''
        ${pkgs.iproute2}/bin/ip link set ${public-wifi} down
        ${pkgs.iproute2}/bin/ip link set ${public-wifi} master bond0
        ${pkgs.iproute2}/bin/ip link set ${public-wifi} up
      '';
    };
  };

  # systemd.network.wait-online.anyInterface = true;
  #
  # systemd.network = {
  #   enable = false;
  #   netdevs = {
  #     "10-enp46s0-dhcp" = {
  #       netdevConfig = {
  #         Kind = "macvlan";
  #         Name = "ethslave";
  #       };
  #       macvlanConfig = {
  #         Mode = "bridge";
  #       };
  #     };
  #     "10-enp46s0-lan" = {
  #       netdevConfig = {
  #         Kind = "macvlan";
  #         Name = "ethvlan";
  #       };
  #       macvlanConfig = {
  #         Mode = "bridge";
  #       };
  #     };
  #     "20-wlan-bond" = {
  #       netdevConfig = {
  #         Kind = "bond";
  #         Name = "bond0";
  #       };
  #       bondConfig = {
  #         Mode = "active-backup";
  #         PrimaryReselectPolicy = "always";
  #         MIIMonitorSec = "1s";
  #         FailOverMACPolicy = "active";
  #       };
  #     };
  #     "20-vmbridge0".netdevConfig = {
  #       Kind = "bridge";
  #       Name = "vmbridge0";
  #     };
  #   };
  #   networks = {
  #     "10-wifi" = {
  #       matchConfig.Name = "wlp0s20f3";
  #       linkConfig.RequiredForOnline = "no";
  #       networkConfig.Bond = "bond0";
  #     };
  #     "10-enp46s0" = {
  #       matchConfig.Name = "enp46s0";
  #       networkConfig.MACVLAN = [
  #         "ethslave" "ethvlan"
  #       ];
  #       linkConfig.ARP = false;
  #     };
  #     "20-enp46s0-dhcp" = {
  #       matchConfig.Name = "ethslave";
  #       linkConfig = {
  #         RequiredForOnline = "no";
  #         ActivationPolicy = "manual";
  #       };
  #       networkConfig = {
  #         Bond = "bond0";
  #         PrimarySlave = true;
  #       };
  #     };
  #     "20-bond0" = {
  #       matchConfig.Name = "bond0";
  #       networkConfig = {
  #         DHCP = "ipv4";
  #         MulticastDNS = true;
  #         LLMNR = false;
  #
  #         IPv6AcceptRA = true;         # accept Router Advertisements
  #         DHCPPrefixDelegation = "yes";# optional — request PD if you need it
  #         LinkLocalAddressing = "ipv4";
  #       };
  #       # [IPv6AcceptRA] section (controls when DHCPv6 client starts)
  #       # ipv6AcceptRAConfig = {
  #       #   # DHCPv6Client = "always";     # force DHCPv6 client even if RA 'managed' flag isn't set
  #       #   UseDNS = false;
  #       # };
  #
  #       # [DHCPv6] section (optional tweaks)
  #       dhcpV6Config = {
  #         UseDNS = false;
  #       };
  #       # dhcpV6Config = {
  #       #   PrefixDelegation = true;
  #       # };
  #     };
  #     "20-enp46s0-lan" = {
  #       matchConfig.Name = "ethvlan";
  #       linkConfig.ActivationPolicy = "manual";
  #       address = [ "192.168.12.1/24" ];
  #     };
  #     "30-vmbridge0" = {
  #       matchConfig.Name = "vmbridge0";
  #       address = [ "192.168.213.1/24" ];
  #       linkConfig.RequiredForOnline = "no";
  #       networkConfig.MulticastDNS = true;
  #     };
  #   };
  # };

  networking.resolvconf = {
    enable = true;
    useLocalResolver = true;
    extraConfig = ''
      dnsmasq_conf=/etc/dnsmasq-conf.conf
      dnsmasq_resolv=/etc/dnsmasq-resolv.conf
    '';
  };

  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      listen-address = [ "127.0.0.1" "192.168.213.1" "192.168.12.1" "172.17.0.1" ];
      server = [ "100.64.0.23" ];
      bind-dynamic = true;
      dhcp-authoritative = true;
      enable-dbus = true;
      hostsdir = "/persist/etc/hosts";
      dhcp-range = [
        "set:vmnet,192.168.213.101,192.168.213.150,255.255.255.0,1w"
        "set:lan,192.168.12.101,192.168.12.150,255.255.255.0,6h"
      ];
      dhcp-option = [
        "tag:vmnet,3,192.168.213.1"
        "tag:lan,3,192.168.12.1"
      ];
      resolv-file = "/etc/dnsmasq-resolv.conf";
      conf-file = "/etc/dnsmasq-conf.conf";
    };
  };
}
