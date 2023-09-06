{ pkgs, myPackages, ... }:
{
  imports = [
    ../exa.nix
  ];

  home.packages = with pkgs; [
    zsh-powerlevel10k

    myPackages.emoji-fzf
  ];

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    defaultKeymap = "emacs";
    envExtra = ''
      GPG_TTY=$TTY
      setopt no_global_rcs
    '';
    sessionVariables = {
      EMOJI_FZF_BIN_PATH = "${myPackages.emoji-fzf}/bin/emoji-fzf";
      EMOJI_FZF_BINDKEY = "^k";
      EMOJI_FZF_FUZZY_FINDER = "${pkgs.fzf}/bin/fzf";
      EMOJI_FZF_CLIPBOARD = "${pkgs.wl-clipboard}/bin/wl-copy";
      FORGIT_COPY_CMD = "${pkgs.wl-clipboard}/bin/wl-copy";
    };
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
          sha256 = "RVX9ZSzjBW3LpFs2W86lKI6vtcvDWP6EPxzeTcRZua4=";
        };
      }
      {
        name = "forgit";
        src = "${pkgs.zsh-forgit}/share/zsh/zsh-forgit";
      }
      {
        name = "emoji-fzf";
        src = pkgs.fetchFromGitHub {
          owner = "pschmitt";
          repo = "emoji-fzf.zsh";
          rev = "75d6feeb67594e0d7e4c5395f2e995b978e14312";
          sha256 = "gfkl4cCKDlynfUZfHymN6JsL+j4lqeFZ0vC7+2SdJIQ=";
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
