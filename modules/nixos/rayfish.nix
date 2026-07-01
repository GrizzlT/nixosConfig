{ pkgs, lib, config, ... }:

{
  environment.systemPackages = [ pkgs.rayfish ];
  systemd.packages = [ pkgs.rayfish ];
  systemd.services.rayfish = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    path = lib.optional config.networking.resolvconf.enable config.networking.resolvconf.package;
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.rayfish}/bin/ray daemon";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
