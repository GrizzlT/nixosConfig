{ lib, vimPlugins, ... }:
with vimPlugins;
{
  neovim.plugins.lualine = {
    package = lualine-nvim;
    event = "VeryLazy";
    dependencies = [ nvim-web-devicons ];
    config = lib.fileContents ./lualine.lua;
  };
}
