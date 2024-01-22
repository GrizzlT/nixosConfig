{ pkgs, lib, vimPlugins, ... }:
with vimPlugins;
let
  opts = desc: { silent = "true"; noremap = "true"; inherit desc; };
in
{
  neovim.plugins = {
    telescope = {
      package = telescope-nvim;
      dependencies = [ plenary-nvim ];
      cmd = "Telescope";
      keys = [
        { lhs = "<leader>pf"; rhs = ''function() require('telescope.builtin').find_files({no_ignore = true}) end''; opts = opts "Find file"; }
        { lhs = "<leader>pp"; rhs = ''function() require('telescope.builtin').git_files() end''; opts = opts "Git files"; }
        { lhs = "<leader>pg"; rhs = ''function() require('telescope.builtin').live_grep() end''; opts = opts "Live grep"; }
        { lhs = "<leader>pb"; rhs = ''function() require('telescope.builtin').buffers() end''; opts = opts "Find buffer"; }
      ];
      config = lib.fileContents ./telescope.lua;
      extraBinaries = with pkgs; [ fd ripgrep ];
    };
    # fzf is built on nixpkgs only
    telescope-fzf.package = pkgs.vimPlugins.telescope-fzf-native-nvim;
    telescope-ui.package = telescope-ui-select-nvim;
  };
}
