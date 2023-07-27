{ pkgs, ... }:
{
  imports = [
    ./exa.nix
  ];

  home.packages = with pkgs; [
    fd
  ];

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    defaultKeymap = "emacs";
    shellAliases = {
      ls = "exa";
      systemUpdate = "sudo nixos-rebuild switch --flake";
      homeUpdate = "home-manager switch --flake";
      weMain = "curl wttr.in/Leuven";
      weSecond = "curl wttr.in/Bonheiden";
    };
    history = {
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
      save = 10000;
    };
    historySubstringSearch.enable = true;
  };
}
