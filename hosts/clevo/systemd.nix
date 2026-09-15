{ config, pkgs, ... }:
{
  systemd.services.user-sleep-grizz = {
    description = "synchronize system sleep with user systemd";
    before = [ "sleep.target" ];
    wantedBy = [ "sleep.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = /* bash */ ''
        ${config.systemd.package}/bin/systemctl --user --machine=grizz@ start --wait user-sleep-barrier.service
      '';
    };
  };

  systemd.user.services.user-sleep-barrier = {
    enable = true;
    description = "user hook to prepare for sleep";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''${pkgs.bashNonInteractive}/bin/bash -c "echo Prepared for sleep"'';
    };
  };

  services.logind.settings.Login = {
    HandleLidSwitch = "hibernate";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "ignore";
  };
}
