{ pkgs, lib, ... }:
let
  modulePath = ../../modules/hm;
in
{
  imports = [
    (modulePath + "/../nix-cache.nix")

    (modulePath + "/headless/broot.nix")
    (modulePath + "/headless/essentials.nix")
    (modulePath + "/headless/eza.nix")
    (modulePath + "/headless/fish.nix")
    (modulePath + "/headless/git-base.nix")
    (modulePath + "/headless/git-extra.nix")
    (modulePath + "/headless/gpg.nix")
    (modulePath + "/headless/neovim.nix")
    (modulePath + "/headless/network-tools.nix")
    (modulePath + "/headless/passage.nix")
    (modulePath + "/headless/productivity.nix")
    (modulePath + "/headless/qmk.nix")

    (modulePath + "/desktop/browser.nix")
    (modulePath + "/desktop/chat.nix")
    (modulePath + "/desktop/document.nix")
    (modulePath + "/desktop/games.nix")
    (modulePath + "/desktop/music.nix")
    (modulePath + "/desktop/sound.nix")
    (modulePath + "/desktop/stylix.nix")
    (modulePath + "/desktop/tech.nix")
    (modulePath + "/desktop/visual.nix")
    (modulePath + "/desktop/wezterm.nix")

    ./wm
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "obsidian"
      "spotify"
      "discord"
    ];
  nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" ];

  home = {
    username = "grizz";
    homeDirectory = "/home/grizz";

    packages = with pkgs; [
      xdg-utils
    ];

    stateVersion = "23.11";
  };
}
