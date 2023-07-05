{ config, pkgs, ... }:
{
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/nixos"
      { directory = "/etc/NetworkManager/system-connections"; user = "root"; group = "root"; mode = "u=rwx,g=,o="; }
    ];
    files = [
      "/etc/machine-id"
      { file = "/etc/shadow"; parentDirectory = { user = "root"; group = "shadow"; mode = "u=rw,g=r,o="; }; }
    ];
  };
}
