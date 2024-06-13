return {
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', },
      'nvim-telescope/telescope-ui-select.nvim',
      'benfowler/telescope-luasnip.nvim',
      'mrcjkb/telescope-manix',
      'debugloop/telescope-undo.nvim',
      'OliverChao/telescope-picker-list.nvim',
    },
    cmd = { "Telescope" },
    keys = {
      { "<leader>pf", function() require('telescope.builtin').find_files({no_ignore = true}) end, desc = "Find file", },
      { "<leader>pp", function() require('telescope.builtin').git_files() end, desc = "Git files", },
      { "<leader>pg", function() require('telescope.builtin').live_grep() end, desc = "Live grep", },
      { "<leader>pb", function() require('telescope.builtin').buffers() end, desc = "Find buffer", },
      { '<leader>pu', '<cmd>Telescope undo<cr>', desc = 'Undo tree' },
      { '<leader>pa', function() require('telescope').extensions.picker_list.picker_list() end, desc = "Telescope pickers" },
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      local actions_layout = require('telescope.actions.layout')
      local trouble = require("trouble.sources.telescope")

      telescope.setup({
        defaults = {
          mappings = {
            n = {
              ["<M-p>"] = actions_layout.toggle_preview,
              ["<c-t>"] = trouble.open,
            },
            i = {
              ["<C-u>"] = false,
              ["<M-p>"] = actions_layout.toggle_preview,
              ["<c-t>"] = trouble.open,
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
        extensions = {
          undo = {
            layout_strategy = "vertical",
            layout_config = {
              preview_height = 0.5,
            },
          },
          picker_list = {},
        },
      })

      telescope.load_extension('fzf')
      telescope.load_extension('ui-select')
      telescope.load_extension('luasnip')
      telescope.load_extension('manix')
      telescope.load_extension("undo")

      -- load last
      telescope.load_extension("picker_list")

    end,
  },
}
