{ pkgs, selfPkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      cd = "z";
      emoj = "${selfPkgs.emoji-fzf}/bin/emoji-fzf preview | fzf -m --preview \"emoji-fzf get --name {1}\" | cut -d \" \" -f 1 | emoji-fzf get";
      "resetup-tide" = "tide configure --auto --style=Classic --prompt_colors='True color' --classic_prompt_color=Light --show_time='24-hour format' --classic_prompt_separators=Angled --powerline_prompt_heads=Sharp --powerline_prompt_tails=Flat --powerline_prompt_style='Two lines, character' --prompt_connection=Solid --powerline_right_prompt_frame=No --prompt_connection_andor_frame_color=Lightest --prompt_spacing=Sparse --icons='Many icons' --transient=Yes";
    };
    shellAbbrs = {
      systemUpdate = "sudo nixos-rebuild switch --flake";
      homeUpdate = "home-manager switch --flake";
    };
    plugins = [
      { name = "forgit"; src = pkgs.fishPlugins.forgit.src; }
      { name = "colored-man-pages"; src = pkgs.fishPlugins.colored-man-pages.src; }
      { name = "tide"; src = pkgs.fishPlugins.tide.src; }
    ];
    interactiveShellInit = ''
      set -x FORGIT_COPY_CMD '${pkgs.wl-clipboard}/bin/wl-copy'
      set -g fish_greeting
    '';
  };
}
