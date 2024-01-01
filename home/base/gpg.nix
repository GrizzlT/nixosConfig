{ config, ... }:
{
  programs.gpg = {
    enable = true;
    homedir = "${config.home.homeDirectory}/DATA/.gnupg";
  };

  services.gpg-agent = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
    defaultCacheTtl = 1200;
    maxCacheTtl = 7200;
  };
}
