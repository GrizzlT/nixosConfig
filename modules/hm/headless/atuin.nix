{ pkgs, config, ... }:
{
  programs.atuin = {
    enable = true;
    package = pkgs.unstable.atuin;
    flags = [
      "--disable-up-arrow"
    ];
    settings = {
      enter_accept = false;
      key_path = "~/DATA/.atuin-key";
      sync_address = "http://100.64.0.2:8011";
      daemon = {
        enabled = true;
        systemd_socket = true;
      };
    };
  };

  systemd.user = {
    services.atuin-daemon = {
      Unit = {
        Description = "Atuin Daemon service";
        Requires = [ "atuin-daemon.socket" ];
        After = [ "atuin-daemon.socket" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${config.programs.atuin.package}/bin/atuin daemon";
        StandardOutput = "journal";
        StandardError = "journal";
      };
      Install.WantedBy = [ "multi-user.target" ];
    };
    sockets.atuin-daemon = {
      Unit = {
        Description = "Atuin Daemon socket";
        Requires = [ "atuin-daemon.service" ];
      };
      Socket = {
        ListenStream="%t/atuin.socket";
        Accept = false;
      };
    };
  };
}
