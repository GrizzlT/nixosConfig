{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      taplo nil ltex-ls
      lua-language-server
      openscad-lsp
      tailwindcss-language-server
      yaml-language-server
      nodePackages.vscode-json-languageserver

      tree-sitter

      unixtools.xxd
      fd ripgrep wl-clipboard
      gccgo gnumake

      manix
    ];
  };
}
