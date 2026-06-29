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
      vscode-langservers-extracted

      just-lsp
      hledger-lsp

      tree-sitter

      unixtools.xxd # Hex toggle
      fd ripgrep wl-clipboard # telescope
      # gccgo gnumake # ???

      manix # search
    ];
  };
}
