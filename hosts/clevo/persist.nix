{ config, pkgs, ... }:
{
  environment.persistence."/persist" = {
    # hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/nixos"
      "/etc/NetworkManager/system-connections"
      { directory = "/etc/shadow"; user = "root"; group = "shadow"; mode = "u=rw,g=r,o="; }
    ];
    files = [
      "/etc/machine-id"
    ];
  };
}
