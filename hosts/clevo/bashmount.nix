{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bashmount
  ];

  environment.etc."bashmount.conf".text = ''
    mount_options='--options noexec,noatime'
  '';
}
