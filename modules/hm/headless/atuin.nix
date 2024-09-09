{ pkgs, ... }:
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
      daemon.enabled = true;
    };
  };
}
