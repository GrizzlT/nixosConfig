return {
  {
    'folke/neodev.nvim',
    priority = 200,
    config = function()
      require('neodev').setup({})
    end,
  },
}
