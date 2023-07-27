{ pkgs, ... }:
{
  # for zsh graphical plugins
  programs.zsh.antidote.plugins = [
    "MichaelAquilina/zsh-auto-notify"
  ];
}
