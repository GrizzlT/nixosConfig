{ pkgs, config, ... }:
let
  emoji-fzf = "${pkgs.emoji-fzf}/bin/emoji-fzf";
  user = config.home.username;
  hostname = config.grizz.settings.hostname;
in
{
  programs.fish = {
    enable = true;
    shellAliases = {
      cd = "__zoxide_z";
      emoj = "${emoji-fzf} preview | fzf -m --preview \"${emoji-fzf} get --name {1}\" | cut -d \" \" -f 1 | ${emoji-fzf} get";
      "resetup-tide" = "tide configure --auto --style=Classic --prompt_colors='True color' --classic_prompt_color=Light --show_time='24-hour format' --classic_prompt_separators=Angled --powerline_prompt_heads=Sharp --powerline_prompt_tails=Flat --powerline_prompt_style='Two lines, character' --prompt_connection=Solid --powerline_right_prompt_frame=No --prompt_connection_andor_frame_color=Lightest --prompt_spacing=Sparse --icons='Many icons' --transient=Yes";
    };
    shellAbbrs = {
      systemUpdate = "sudo nixos-rebuild switch --flake '.#${hostname}'";
      homeUpdate = "home-manager switch --flake '.#${user}@${hostname}'";
    };
    plugins = [
      { name = "forgit"; src = pkgs.fishPlugins.forgit.src; }
      { name = "colored-man-pages"; src = pkgs.fishPlugins.colored-man-pages.src; }
      { name = "tide"; src = pkgs.fishPlugins.tide.src; }
    ];
    interactiveShellInit = ''
      set -x FORGIT_COPY_CMD '${pkgs.wl-clipboard}/bin/wl-copy'
      set -g fish_greeting

      refresh_nix_envs
    '';
    functions.refresh_nix_envs = ''
      for file in $GRIZZ_PROFILES/*
        if not string match -q --regex -- '-link$' $file
          fish_add_path $file/bin || true
        end
      end
    '';
  };
  home.sessionVariables = {
    GRIZZ_PROFILES = "$HOME/.nix-envs";
  };
}
