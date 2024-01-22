{ lib, vimPlugins, ... }:
with vimPlugins;
{
  neovim.plugins = {
    rust-tools = {
      package = rust-tools-nvim;
      ft = "rust";
      dependencies = [ nvim-lspconfig ];
      config = lib.fileContents ./rust-tools.lua;
    };
    crates = {
      package = crates-nvim;
      event = "BufRead Cargo.toml";
      dependencies = [ plenary-nvim nvim-cmp ];
      config = lib.fileContents ./crates.lua;
    };
  };
}
