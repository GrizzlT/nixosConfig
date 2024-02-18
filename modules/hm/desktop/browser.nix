{ pkgs, ... }:
{
  programs.librewolf = {
    enable = true;
    # TODO: add settings
  };

  home.packages = with pkgs; [
    (firefox.override { pkcs11Modules = [ pkgs.eid-mw ]; })
    brave
  ];
}
