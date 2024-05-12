hostName: hostId:
{ pkgs, lib, config, ... }:
{
  environment.systemPackages = with pkgs; [
    dnsmasq
  ];

  services.resolved = {
    enable = true;
    domains = [ "~." ];
    fallbackDns = [ "1.1.1.1" ];
    dnssec = "false";
    extraConfig = ''
      DNSStubListener=no
      LLMNR=no
    '';
  };
  networking = {
    networkmanager.enable = lib.mkForce false;
    nameservers = [ "127.0.0.1" "::1" ];
    useDHCP = false;
    dhcpcd.extraConfig = "nohook resolv.conf";

    hostId = hostId;
    hostName = hostName;

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

  systemd.network = {
    enable = true;
    netdevs = {
      "20-vmbridge0".netdevConfig = {
        Kind = "bridge";
        Name = "vmbridge0";
      };
    };
    networks = {
      "10-wifi" = {
        matchConfig.Name = "wlp0s20f3";
        linkConfig.RequiredForOnline = "no";
        networkConfig = {
          DHCP = "ipv4";
        };
        dhcpV4Config.UseDNS = false;
      };
      "20-enp46s0" = {
        #### When connecting to external network ####
        matchConfig.Name = "enp46s0";
        linkConfig.RequiredForOnline = "no";
        networkConfig.DHCP = "ipv4";
        dhcpV4Config.UseDNS = false;
        #### When used to set up LAN ####
        # address = [ "192.168.12.1/24" ];
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
      server = [ "10.123.13.3" ];
      dhcp-authoritative = true;
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
