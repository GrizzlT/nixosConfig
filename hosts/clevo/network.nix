{ pkgs, lib, config, ... }:
let
  public-ethernet = "enp46s0";
  public-wifi = "wlp0s20f3";
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

    wireless.iwd.enable = false;
    wireless.enable = true;
    wireless.userControlled.enable = true;
    wireless.allowAuxiliaryImperativeNetworks = true;
    wireless.extraConfigFiles = [ "/persist/etc/wpa_supplicant/wireless.conf" ];
  };
  systemd.services.wpa_supplicant.serviceConfig.NetworkNamespacePath = "/var/run/netns/physical";
  systemd.services.iwd.serviceConfig.NetworkNamespacePath = "/var/run/netns/physical";

  networking.dhcpcd = {
    enable = true;
    allowInterfaces = [ "bond0" ];
    extraConfig = ''
      nohook resolv.conf
      noipv4ll
    '';
  };
  systemd.services.dhcpcd.serviceConfig.NetworkNamespacePath = "/var/run/netns/physical";

  systemd.services.setup-public-network = {
    before = [ "dhcpcd.service" "iwd.service" "wpa_supplicant.service" "tailscaled.service" "avahi-daemon.service" "nftables-physical.service" "kea-dhcp4-server.service" ];
    after = [ "dbus.service" "nftables.service" ];
    wants = [ "dbus.service" "nftables.service" ];
    wantedBy = [ "multi-user.target" "iwd.service" "avahi-daemon.service" "tailscaled.service" "dhcpcd.service" "nftables-physical.service" "kea-dhcp4-server.service" ];
    requiredBy = [ "iwd.service" "wpa_supplicant.service" "tailscaled.service" "avahi-daemon.service" "dhcpcd.service" "nftables-physical.service" "kea-dhcp4-server.service" ];

    path = [ pkgs.openresolv pkgs.nftables ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "setup-public-network" /* bash */ ''
        ${pkgs.iproute2}/bin/ip netns add physical
        ${pkgs.iproute2}/bin/ip link set ${public-ethernet} netns physical
        ${pkgs.iw}/bin/iw phy phy0 set netns name physical

        ${pkgs.iproute2}/bin/ip -n physical link set lo up

        ${pkgs.iproute2}/bin/ip -n physical link add ethslave link ${public-ethernet} type macvlan mode bridge
        ${pkgs.iproute2}/bin/ip -n physical link add bond0 type bond miimon 100 mode active-backup fail_over_mac none primary_reselect always primary ethslave
        ${pkgs.iproute2}/bin/ip -n physical link set ethslave master bond0
        ${pkgs.iproute2}/bin/ip -n physical link set ${public-wifi} master bond0

        ${pkgs.iproute2}/bin/ip -n physical link set ${public-ethernet} up
        ${pkgs.iproute2}/bin/ip -n physical link set ${public-wifi} up

        ${pkgs.iproute2}/bin/ip link set ${public-ethernet} up
        ${pkgs.iproute2}/bin/ip link set ${public-wifi} up

        ${pkgs.iproute2}/bin/ip -n physical link add dev mullvad type wireguard
        ${pkgs.iproute2}/bin/ip -n physical link set mullvad netns 1
        ${pkgs.wireguard-tools}/bin/wg setconf mullvad <(${pkgs.wireguard-tools}/bin/wg-quick strip /home/grizz/DATA/.mullvad/default.conf)
        ${pkgs.iproute2}/bin/ip addr add 10.74.26.182/32 dev mullvad
        ${pkgs.iproute2}/bin/ip addr add fc00:bbbb:bbbb:bb01::b:1ab5/128 dev mullvad
        ${pkgs.iproute2}/bin/ip link set mullvad up
        ${pkgs.iproute2}/bin/ip -4 route add default dev mullvad
        ${pkgs.iproute2}/bin/ip -6 route add default dev mullvad
        ${pkgs.iproute2}/bin/ip route add 100.64.0.2/32 dev mullvad

        ${pkgs.iproute2}/bin/ip link add lan-virtual type veth peer name lan-physical netns physical
        ${pkgs.iproute2}/bin/ip link set lan-virtual up
        ${pkgs.iproute2}/bin/ip -n physical link set lan-physical up

        ${pkgs.iproute2}/bin/ip addr add 198.18.13.13/30 dev lan-virtual
        ${pkgs.iproute2}/bin/ip -n physical addr add 198.18.13.14/30 dev lan-physical
        ${pkgs.iproute2}/bin/ip route add 192.168.0.0/16 via 198.18.13.14 dev lan-virtual

        ${pkgs.iproute2}/bin/ip -n physical link add ethvlan link ${public-ethernet} type macvlan mode bridge
        ${pkgs.iproute2}/bin/ip -n physical link set ethvlan down
        ${pkgs.iproute2}/bin/ip -n physical addr add 192.168.12.1/24 dev ethvlan

        ${pkgs.iproute2}/bin/ip link add vmbridge0 type bridge
        ${pkgs.iproute2}/bin/ip link set vmbridge0 up
        ${pkgs.iproute2}/bin/ip addr add 192.168.213.1/24 dev vmbridge0
      '';
      ExecStop = pkgs.writeShellScript "shutdown-public-network" /* bash */ ''
        ${pkgs.iproute2}/bin/ip link del mullvad

        ${pkgs.iproute2}/bin/ip -n physical link set ${public-ethernet} netns 1
        ${pkgs.iw}/bin/iw phy ${public-wifi} set netns 1
        ${pkgs.iproute2}/bin/ip netns del physical
      '';
    };
  };
  systemd.services.force-iwd-mac = {
    after = [ "iwd.service" "wpa_supplicant.service" "setup-public-network.service" ];
    wantedBy = [ "iwd.service" "wpa_supplicant.service" "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "reset-iwd-wlan-master" /* bash */ ''
        ${pkgs.iproute2}/bin/ip -n physical link set ${public-wifi} down
        ${pkgs.iproute2}/bin/ip -n physical link set ${public-wifi} master bond0
        ${pkgs.iproute2}/bin/ip -n physical link set ${public-wifi} up
      '';
    };
  };

  networking.nameservers = [ "100.64.0.2" ];
  networking.resolvconf = {
    enable = true;
    useLocalResolver = true;
    extraConfig = ''
      # dnsmasq_conf=/etc/dnsmasq-conf.conf
      # dnsmasq_resolv=/etc/dnsmasq-resolv.conf
      # Write out unbound configuration file
      unbound_conf=/etc/unbound-resolvconf.conf
    '';
  };

  systemd.services.rayfish.after = [ "dnsmasq.service" "unbound.service" ];
  systemd.services.dnsmasq.after = [ "resolvconf.service" ];
  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      listen-address = [ "192.168.213.1" "198.18.13.13" ];
      server = [ "127.0.0.1" ];
      bind-dynamic = true;
      dhcp-authoritative = true;
      enable-dbus = true;
      hostsdir = "/persist/etc/hosts";
      dhcp-range = [
        "set:vmnet,192.168.213.101,192.168.213.150,255.255.255.0,1w"
      ];
      dhcp-option = [
        "tag:vmnet,3,192.168.213.1"
      ];
      resolv-file = "/etc/dnsmasq-resolv.conf";
      conf-file = "/etc/dnsmasq-conf.conf";
    };
  };
  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = [ "127.0.0.1" ];
        val-permissive-mode = true;
      };
      stub-zone = [
        {
          name = "ray.";
          stub-addr = [ "100.100.100.53" ];
        }
        {
          name = "vpn.private.";
          stub-host = [ "xub.personal.ray" ];
        }
      ];
      remote-control.control-enable = true;
      include = "/etc/unbound-resolvconf.conf";
    };
  };

  systemd.services.kea-dhcp4-server.serviceConfig.NetworkNamespacePath = "/var/run/netns/physical";
  services.kea.dhcp4 = {
    enable = true;
    settings = {
      # First we set up global values
      valid-lifetime = 4000;
      renew-timer = 1000;
      rebind-timer = 2000;
      interfaces-config = {
        interfaces = [
          "ethvlan"
        ];
      };
      lease-database = {
        name = "/var/lib/kea/dhcp4.leases";
        persist = true;
        type = "memfile";
      };
      subnet4 = [
        {
          id = 1;
          pools = [
            {
              pool = "192.168.12.101 - 192.168.12.150";
            }
          ];
          subnet = "192.168.12.0/24";
        }
      ];
      option-data = [
        {
          name = "domain-name-servers";
          data = "192.168.12.1";
        }
        {
          name = "routers";
          data = "192.168.12.1";
        }
      ];
    };
  };
}
