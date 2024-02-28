return {
  {
    'sindrets/diffview.nvim',
    cmd = {  "DiffviewFileHistory", "DiffviewOpen", "DiffviewToggleFiles", },
    keys = {
        { "<leader>do", "<cmd>DiffviewOpen<cr>", desc = "Open diffview", },
        { "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "Close diffview", },
        { "<leader>df", "<cmd>DiffviewFileHistory<cr>", desc = "Git file history", },
        { "<leader>dF", "<cmd>DiffviewToggleFiles<cr>",  desc = "Toggle git files", },
    },
  },

  {
    'kdheepak/lazygit.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'LazyGit', },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit", },
    },
  },
}
