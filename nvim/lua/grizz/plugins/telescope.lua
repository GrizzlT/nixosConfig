return {
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
    },
    cmd = { "Telescope" },
    keys = {
      { "<leader>pf", function() require('telescope.builtin').find_files({no_ignore = true}) end, desc = "Find file", },
      { "<leader>pp", function() require('telescope.builtin').git_files() end, desc = "Git files", },
      { "<leader>pg", function() require('telescope.builtin').live_grep() end, desc = "Live grep", },
      { "<leader>pb", function() require('telescope.builtin').buffers() end, desc = "Find buffer", },
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      local actions_layout = require('telescope.actions.layout')
      local trouble = require("trouble.providers.telescope")

      telescope.setup({
        defaults = {
          mappings = {
            n = {
              ["<M-p>"] = actions_layout.toggle_preview,
              ["<c-t>"] = trouble.open_with_trouble,
            },
            i = {
              ["<C-u>"] = false,
              ["<M-p>"] = actions_layout.toggle_preview,
              ["<c-t>"] = trouble.open_with_trouble,
            },
          }
        },
        pickers = {
          buffers = {
            mappings = {
              i = {
                ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
              }
            }
          },
        },
      })

      telescope.load_extension('fzf')
      telescope.load_extension('ui-select')
      pcall(telescope.load_extension, 'luasnip')
    end,
  },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
  },
  'nvim-telescope/telescope-ui-select.nvim',
  'benfowler/telescope-luasnip.nvim',
}
