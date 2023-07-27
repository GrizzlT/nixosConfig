{ pkgs, ... }:
{
  imports = [
    ./exa.nix
  ];

  home.packages = with pkgs; [
    fd
    zsh-powerlevel10k
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
    envExtra = ''
      setopt no_global_rcs
    '';
    shellAliases = {
      ls = "exa";
      systemUpdate = "sudo nixos-rebuild switch --flake";
      homeUpdate = "home-manager switch --flake";
      weMain = "${pkgs.curl}/bin/curl wttr.in/Leuven";
      weSecond = "${pkgs.curl}/bin/curl wttr.in/Bonheiden";
    };
    history = {
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
      save = 10000;
    };
    initExtra = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k
    '';
  };
}
