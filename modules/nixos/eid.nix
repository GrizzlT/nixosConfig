{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    eid-mw
  ];

  services.pcscd.enable = true;
}
