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
  };

  environment.etc."machine-id".source = "/persist/etc/machine-id";
  environment.etc."group".source = "/persist/etc/group";
  environment.etc."shadow".source = "/persist/etc/shadow";
  environment.etc."passwd".source = "/persist/etc/passwd";
  environment.etc."subgid".source = "/persist/etc/subgid";
  environment.etc."subuid".source = "/persist/etc/subuid";
  environment.etc."sudoers".source = "/persist/etc/sudoers";
}
