{ vimPlugins, ... }:
with vimPlugins;
let
  opts = desc: { silent = "true"; noremap = "true"; inherit desc; };
in {
  neovim.plugins = {
    diffview = {
      package = diffview-nvim;
      cmd = [ "DiffviewFileHistory" "DiffviewOpen" "DiffviewToggleFiles" ];
      keys = [
        { lhs = "<leader>do"; rhs = "<cmd>DiffviewOpen<cr>"; opts = opts "Open diffview"; }
        { lhs = "<leader>dc"; rhs = "<cmd>DiffviewClose<cr>"; opts = opts "Close diffview"; }
        { lhs = "<leader>df"; rhs = "<cmd>DiffviewFileHistory<cr>"; opts = opts "Git file history"; }
        { lhs = "<leader>dF"; rhs = "<cmd>DiffviewToggleFiles<cr>"; opts = opts "Toggle git files"; }
      ];
    };

    lazygit = {
      package = lazygit-nvim;
      cmd = [ "LazyGit" ];
      keys = [
        { lhs = "<leader>gg"; rhs = "<cmd>LazyGit<cr>"; opts = opts "LazyGit"; }
      ];
    };
  };
}
