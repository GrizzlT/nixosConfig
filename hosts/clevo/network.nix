{ pkgs, lib, config, ... }:
{
  environment.systemPackages = with pkgs; [
    dnsmasq
  ];

  services.resolved = {
    enable = true;
    fallbackDns = [ "9.9.9.9" "149.112.112.112" ];
    domains = [ "hostfile" ];
    dnssec = "false";
    extraConfig = ''
      LLMNR=no
      DNS=127.0.1.53
    '';
  };
  networking = {
    networkmanager.enable = lib.mkForce false;
    useDHCP = false;
    dhcpcd.extraConfig = "nohook resolv.conf";

    hostId = "13eb44cc";

    wireless = {
      userControlled.enable = true;
      enable = true;
      allowAuxiliaryImperativeNetworks = true;
      environmentFile = config.age.secrets.wpaPasswords.path;
      networks = {
        "Tapaki" = {
          psk = "@TAPAKI_PASSWORD@";
          priority = 10;
        };
        "TOP" = {
          psk = "@TOP_PASSWORD@";
          priority = 10;
        };
        "OnePlus Nord CE 2 Lite" = {
          psk = "@ROB_HOTSPOT@";
        };
        "TP-Link_4DA4" = {
          psk = "@ROB_DORM@";
        };
      };
    };
  };

  systemd.network.wait-online.anyInterface = true;

  systemd.network = {
    enable = true;
    netdevs = {
      "10-enp46s0-dhcp" = {
        netdevConfig = {
          Kind = "macvlan";
          Name = "ethslave";
        };
        macvlanConfig = {
          Mode = "vepa";
        };
      };
      "10-enp46s0-lan" = {
        netdevConfig = {
          Kind = "macvlan";
          Name = "ethvlan";
        };
        macvlanConfig = {
          Mode = "bridge";
        };
      };
      "20-wlan-bond" = {
        netdevConfig = {
          Kind = "bond";
          Name = "bond0";
        };
        bondConfig = {
          Mode = "active-backup";
          PrimaryReselectPolicy = "always";
          MIIMonitorSec = "1s";
        };
      };
      "20-vmbridge0".netdevConfig = {
        Kind = "bridge";
        Name = "vmbridge0";
      };
    };
    networks = {
      "10-wifi" = {
        matchConfig.Name = "wlp0s20f3";
        linkConfig.RequiredForOnline = "no";
        networkConfig.Bond = "bond0";
      };
      "10-enp46s0" = {
        matchConfig.Name = "enp46s0";
        networkConfig.MACVLAN = [
          "ethslave" "ethvlan"
        ];
        linkConfig.ARP = false;
      };
      "20-enp46s0-dhcp" = {
        matchConfig.Name = "ethslave";
        linkConfig.RequiredForOnline = "no";
        networkConfig = {
          Bond = "bond0";
          PrimarySlave = true;
        };
      };
      "20-bond0" = {
        matchConfig.Name = "bond0";
        networkConfig = {
          DHCP = "ipv4";
          MulticastDNS = true;
          LLMNR = false;
        };
      };
      "20-enp46s0-lan" = {
        matchConfig.Name = "ethvlan";
        linkConfig.ActivationPolicy = "manual";
        address = [ "192.168.12.1/24" ];
      };
      "30-vmbridge0" = {
        matchConfig.Name = "vmbridge0";
        address = [ "192.168.213.1/24" ];
        linkConfig.RequiredForOnline = "no";
      };
    };
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      listen-address = "127.0.1.53";
      bind-interfaces = true;
      server = [ "127.0.0.53" "/hostfile/" ];
      no-resolv = true;
      dhcp-authoritative = true;
      no-poll = true;
      hostsdir = "/persist/etc/hosts";
      dhcp-range = [
        "set:vmnet,192.168.213.101,192.168.213.150,255.255.255.0,1w"
        "set:lan,192.168.12.101,192.168.12.150,255.255.255.0,6h"
      ];
      dhcp-option = [
        "tag:vmnet,3,192.168.213.1"
        "tag:lan,3,192.168.12.1"
      ];
    };
  };

  networking.extraHosts = ''
    127.0.0.1 test1.example.org
    127.0.0.1 test2.example.org
    127.0.0.1 test3.example.org
  '';
}
