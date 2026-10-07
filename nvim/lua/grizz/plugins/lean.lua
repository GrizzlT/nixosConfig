return {
  {
    'Julian/lean.nvim',
    event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },
    lazy = true,

    dependencies = {
      -- optional dependencies:

      'nvim-telescope/telescope.nvim', -- for Lean-specific pickers
      'andymass/vim-matchup',          -- for enhanced % motion behavior
      -- 'andrewradev/switch.vim',        -- for switch support
      'tomtom/tcomment_vim',           -- for commenting
    },

    config = function()
      vim.g.lean_config = {
        mappings = true,
      }
    end,
  }
}
