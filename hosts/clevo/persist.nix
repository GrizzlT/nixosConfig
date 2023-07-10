{ config, pkgs, ... }:
{
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      { directory = "/etc/NetworkManager/system-connections"; user = "root"; group = "root"; mode = "u=rwx,g=,o="; }
      { directory = "/var/log/regreet"; user = "greeter"; group = "greeter"; }
      { directory = "/var/cache/regreet"; user = "greeter"; group = "greeter"; }
    ];
  };

  environment.etc."machine-id".source = "/persist/etc/machine-id";
}
