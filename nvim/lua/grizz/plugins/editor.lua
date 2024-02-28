return {
  {
    'numToStr/Comment.nvim',
    lazy = false;
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring', },
    keys = {
      { "gcc", }, { "gco", }, { "gcO", }, { "gcb", }, { "gcA", }, { "gc", },
      { "gc", mode = { "v" }, }, { "gb", mode = { "v" }, },
    },
    config = function()
      require('Comment').setup({
	pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end,
  },

  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { "<leader>-", "<cmd>Oil<cr>", desc = "Open file explorer", },
    },
    config = function() require("oil").setup({
      view_options = {
	show_hidden = true,
      },
    }) end,
  },

  {
    'iamcco/markdown-preview.nvim',
    cmd = {  "MarkdownPreview", "MarkdownPreviewToggle" },
    ft = { 'markdown' },
    build = function() vim.fn["mkdp#util#install"]() end,
  },

  {
    'RaafatTurki/hex.nvim',
    cmd = { 'HexDump', 'HexToggle', 'HexAssemble' },
    config = function() require('hex').setup() end,
  },
}
