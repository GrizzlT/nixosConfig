{ pkgs, ... }:
{
  # for zsh graphical plugins
  programs.antidote.plugins = [
    "MichaelAquilina/zsh-auto-notify"
  ];
}
