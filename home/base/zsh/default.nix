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
      GPG_TTY=$TTY
      setopt no_global_rcs
    '';
    shellAliases = {
      ls = "exa";
      cd = "z";
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
    plugins = [
      {
        name = "fast-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma-continuum";
          repo = "fast-syntax-highlighting";
          rev = "cf318e06a9b7c9f2219d78f41b46fa6e06011fd9";
        };
      }
    ];
    initExtraFirst = ''
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';
    initExtra = ''
      bindkey '^ ' autosuggest-accept

      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
      [[ ! -f ${./p10k.zsh} ]] || source ${./p10k.zsh};
    '';
  };
}
