{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      taplo nil ltex-ls
      lua-language-server
      openscad-lsp

      unixtools.xxd
      fd ripgrep wl-clipboard
      gccgo gnumake

      manix
    ];
  };
}
