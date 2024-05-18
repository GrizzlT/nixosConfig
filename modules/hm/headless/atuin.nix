{ ... }:
{
  programs.atuin = {
    enable = true;
    settings = {
      enter_accept = false;
      key_path = "~/DATA/.atuin-key";
      sync_address = "http://100.64.0.2:8011";
    };
  };
}
