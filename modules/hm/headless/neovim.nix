{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      taplo nil ltex-ls
      unixtools.xxd
      fd ripgrep wl-clipboard
      gccgo gnumake
    ];
  };
}
