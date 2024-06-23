{ config, ... }:
{
  programs.zellij = {
    enable = true;
  };

  xdg.configFile."zellij/config.kdl".text =
    builtins.readFile (config.grizz.settings.flakeDir + "/zellij/keybinds.kdl");

  stylix.targets.zellij.enable = true;
}
