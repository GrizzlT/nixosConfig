{ ... }:
{
  imports = [
    ./plugins/colorscheme.nix
    ./plugins/editor.nix
    ./plugins/git.nix
    ./plugins/lsp.nix
    ./plugins/lualine.nix
    ./plugins/rust-tools.nix
    ./plugins/syntax.nix
    ./plugins/telescope.nix
    ./plugins/treesitter.nix
    ./plugins/trouble.nix
  ];
}
