{ pkgs, vimPlugins, ... }:
let
  onedarkpro-pkg = let
    neovim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
      configure.packages = {
        onedarkpro.start = [vimPlugins.onedarkpro-nvim];
      };
    };
  in
    pkgs.runCommand "onedarkpro-nvim-compile-cached" {} ''
      mkdir -p $out/lua/lualine/themes
      ${neovim}/bin/nvim -l ${./onedarkpro-nvim-config.lua}
      cd $out/colors
      rm cache
    '';
in
{
  neovim.plugins = {
    onedarkpro = {
      package = onedarkpro-pkg;
      lazy = false;
      priority = 1000;
      config = "vim.cmd[[colorscheme onedark]]";
    };
  };
}
