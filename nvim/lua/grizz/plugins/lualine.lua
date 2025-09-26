return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', },
    event = "VeryLazy",
    config = function()
      require('lualine').setup({
        options = {
          -- theme = require('lualine.themes.onedark'),
          theme = 'nordic',
          globalstatus = true,
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 'filename' },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'searchcount' },
          lualine_z = { 'location' },
        }
      })
    end,
  },
}
