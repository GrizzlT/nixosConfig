return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { 'Trouble', 'TroubleToggle', },
    keys = {
      { "<leader>td", "<cmd>Trouble document_diagnostics<cr>", desc = "Document diagnostics", },
      { "<leader>tw", "<cmd>Trouble workspace_diagnostics<cr>", desc = "Workspace diagnostics", },
      { "<leader>tD", "<cmd>Trouble lsp_definitions<cr>", desc = "LSP definitions", },
      { "<leader>tr", "<cmd>Trouble lsp_references<cr>", desc = "LSP references", },
      { "<leader>to", "<cmd>Trouble lsp_type_definitions<cr>", desc = "LSP type definitions", },
    },
    config = function()
      require('trouble').setup()
    end,
  },

  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = { 'InsertEnter' },
    keys = {
      { "<leader>tt", "<cmd>TodoTrouble<cr>", desc = "Todo Trouble", },
      { "<leader>tT", "<cmd>TodoTelescope<cr>", desc = "Todo Telescope", },
    },
    config = function()
      require('todo-comments').setup()
    end,
  },
}
