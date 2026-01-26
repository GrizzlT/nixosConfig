{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    eid-mw
    beidconnect
    web-eid-app
  ];

  services.pcscd.enable = true;
}
