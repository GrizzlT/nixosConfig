{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    eid-mw
    beidconnect
  ];

  services.pcscd.enable = true;
}
