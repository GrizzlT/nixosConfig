{ vimPlugins, ... }:
with vimPlugins;
{
  neovim.plugins.typst-vim = {
    package = typst-vim;
    ft = "typst";
    lazy = false;
  };
}
