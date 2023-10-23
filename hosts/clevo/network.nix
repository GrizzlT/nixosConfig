hostName: hostId:
{ pkgs, lib, config, ... }:
let
  # Whether to share internet from the ethernet port over wifi or reverse
  # ethernetToWifi = false;
in
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
  networking.nameservers = [ "127.0.0.1" "::1" ];
  networking.useDHCP = false;
  networking.dhcpcd.extraConfig = "nohook resolv.conf";
  # networking.interfaces.wlp0s20f3.useDHCP = !ethernetToWifi;
  # networking.interfaces.enp46s0.useDHCP = ethernetToWifi;
  networking.interfaces.wlp0s20f3.useDHCP = true;
  networking.interfaces.enp46s0.useDHCP = true;
  networking.hostId = hostId;
  networking.hostName = hostName;

  systemd.network = {
    enable = true;
    netdevs = {
      "20-vmbridge0".netdevConfig = {
        Kind = "bridge";
        Name = "vmbridge0";
      };
    };
    networks = {
      "30-vmbridge0" = {
        matchConfig.Name = "vmbridge0";
        address = [ "192.168.213.1/24" ];
        linkConfig.RequiredForOnline = "no";
      };
    };
    # } // lib.optionalAttrs (!ethernetToWifi) {
    #   "40-enp46s0" = {
    #     matchConfig.Name = "enp46s0";
    #     address = [ "192.168.12.1/24" ];
    #     linkConfig.RequiredForOnline = "no";
    #   };
    # };
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      server = [ "100.91.153.130" ];
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

  networking.networkmanager = {
    enable = true;
    # unmanaged = [ (if ethernetToWifi then "except:interface-name:enp46s0" else "except:interface-name:wlp0s20f3") ];
    firewallBackend = "nftables";
    dns = lib.mkForce "none";
    extraConfig = ''
      [main]
      systemd-resolved=false
    '';
  };
  networking.extraHosts = ''
    127.0.0.1 test1.example.org
    127.0.0.1 test2.example.org
    127.0.0.1 test3.example.org
  '';
  # services.create_ap = {
  #   enable = ethernetToWifi;
  #   settings = {
  #     CHANNEL="default";
  #     GATEWAY="192.168.12.1";
  #     WPA_VERSION=2;
  #     ETC_HOSTS=0;
  #     DHCP_DNS="gateway";
  #     NO_DNS=1;
  #     NO_DNSMASQ=1;
  #     HIDDEN=0;
  #     MAC_FILTER=0;
  #     MAC_FILTER_ACCEPT="/etc/hostapd/hostapd.accept";
  #     ISOLATE_CLIENTS=0;
  #     SHARE_METHOD="nat";
  #     IEEE80211N=1;
  #     IEEE80211AC=1;
  #     HT_CAPAB="[HT40+]";
  #     VHT_CAPAB="";
  #     DRIVER="nl80211";
  #     NO_VIRT=1;
  #     COUNTRY="";
  #     FREQ_BAND="2.4";
  #     NEW_MACADDR="";
  #     DAEMONIZE=0;
  #     DAEMON_PIDFILE="";
  #     DAEMON_LOGFILE="/dev/null";
  #     NO_HAVEGED=0;
  #     WIFI_IFACE="wlp0s20f3";
  #     INTERNET_IFACE="enp46s0";
  #     SSID="Clevo Hotspot";
  #     PASSPHRASE="0KChFbe[Lz";
  #     USE_PSK=0;
  #     ADDN_HOSTS="";
  #   };
  # };
}
