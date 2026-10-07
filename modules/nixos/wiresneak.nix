{ config, lib, pkgs, ... }:

let
  cfg = config.services.wiresneakd;
  inherit (lib) mkOption mkEnableOption types;

  peerModule = { name, ... }: {
    options = {
      publicKey = mkOption {
        type = types.str;
        description = "Public Key of the peer.";
        example = "abcd123f...";
      };

      allowedIPs = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "CIDR ranges accepted from this peer";
        example = [ "10.0.0.0/24" ];
      };
    };
  };

  networkModule = { name, ... }: {
    options = {
      enabled = mkEnableOption "Enable ${name} tunnel";

      privateKey = mkOption {
        type = types.path;
        description = ''
          Path to the private key file.
        '';
        example = "/etc/path/to/key";
      };

      addresses = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Addresses (CIDR notation) assigned to the interface.";
        example = [ "10.0.0.1/24" ];
      };

      peers = mkOption {
        type = types.attrsOf (types.submodule peerModule);
        default = { };
        description = "Peers of this network, keyed by peer name.";
      };
    };
  };
in
{
  options.services.wiresneakd = {
    package = mkOption {
      type = types.package;
      default = pkgs.wiresneak;
      defaultText = lib.literalExpression "pkgs.wiresneak";
      description = "The package to use.";
    };
    networks = mkOption {
      type = types.attrsOf (types.submodule networkModule);
      default = { };
      description = "Networks to configure, keyed by interface name (e.g. tun0).";
    };
  };

  config = {

    systemd.services = lib.mapAttrs' (name: value: let
      peers = lib.concatMapAttrsStringSep "\n" (name: value: ''
        # Peer ${name}
        [[Peer]]
        PublicKey = "${value.publicKey}"
        AllowedIPs = [${lib.concatMapStringsSep "," (v: "\"${v}\"") value.allowedIPs}]
      '') value.peers;
      configFile = pkgs.writeText "config-wiresneak-${name}" ''
        [Interface]
        PrivateKey = "${value.privateKey}"
        Addresses = [${lib.concatMapStringsSep "," (v: "\"${v}\"") value.addresses}]

        ${peers}
      '';
      ipAddrCmds = lib.concatMapStringsSep "\n" (addr: "ip addr add ${addr} dev ${name}") value.addresses or [];
    in {
      name = "wiresneak-${name}";
      value = {
        description = "wiresneak tunnel for interface ${name}";
        wantedBy = ["multi-user.target"];
        wants = ["network.target"];
        after = ["network.target"];

        path = [ pkgs.iproute2 ];
        serviceConfig = {
          Type = "notify";
          ExecStart = "${cfg.package}/bin/wiresneakd serve ${configFile} ${name}";
          ExecStartPost = pkgs.writeShellScript "wiresneak-set-addrs-${name}" ''
            ${ipAddrCmds}
            ip link set up ${name}
          '';
        };
      };
    }) cfg.networks;
  };
}
