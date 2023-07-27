{ pkgs, ... }:
{
  imports = [
    ../exa.nix
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
    initExtraFirst = ''
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';
    initExtra = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    '';
  };

  home.file.".p10k.zsh".source = ./p10k.zsh;
}
