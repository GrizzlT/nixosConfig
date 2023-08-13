{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [ xplr ];

  home.file.".config/xplr/init.lua".text = ''
    version = '${lib.getVersion pkgs.xplr}'

    xplr.config.general.show_hidden = true
  '';
}
