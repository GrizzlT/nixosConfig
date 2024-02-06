{ pkgs, lib, vimPlugins, ... }:
with vimPlugins;
# let
  # opts = desc: { silent = "true"; noremap = "true"; inherit desc; };
# in
{
  neovim.plugins = {
    obsidian-nvim = {
      package = obsidian-nvim;
      dependencies = [ plenary-nvim telescope-nvim nvim-cmp ];
      ft = "markdown";
      cmd = [ "ObsidianWorkspace" ];
      extraBinaries = with pkgs; [ ripgrep wl-clipboard ];
      config = lib.fileContents ./obsidian.lua;
    };
  };
}
