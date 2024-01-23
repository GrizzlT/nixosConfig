{ pkgs, lib, selfHm, ... }:
{
  imports = with selfHm; [
    headless.broot
    headless.essentials
    headless.eza
    headless.fish
    headless.git-base
    headless.git-extra
    headless.gpg
    headless.neovim
    headless.network-tools
    headless.passage
    headless.productivity

    desktop.browser
    desktop.chat
    desktop.document
    desktop.games
    desktop.music
    desktop.sound
    desktop.stylix
    desktop.visual
    desktop.wezterm

    ./wm
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "spotify"
      "discord"
    ];

  home = {
    username = "grizz";
    homeDirectory = "/home/grizz";

    packages = with pkgs; [
      xdg-utils
    ];

    stateVersion = "23.11";
  };
}
