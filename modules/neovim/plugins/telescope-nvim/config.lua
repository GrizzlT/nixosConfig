local telescope = require('telescope')
local actions = require('telescope.action')
local action_layout = require('telescope.action.layout')
local trouble = require('trouble')
local builtin = require('telescope.builtin')
local map = vim.api.nvim_set_keymap

telescope.setup({
  defaults = {
    mappings = {
      n = {
        ["<M-p>"] = action_layout.toggle_preview,
        ["<c-t>"] = trouble.open_with_trouble,
      },
      i = {
        ["<C-u>"] = false,
        ["<M-p>"] = action_layout.toggle_preview,
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

map("n", '<leader>pf', builtin.find_files, { desc = "Find file" })
map("n", '<leader>pp', builtin.git_files, { desc = "Git files" } )
map("n", '<leader>pg', builtin.live_grep, { desc = "Live grep" } )
map("n", '<leader>pb', builtin.buffers, { desc = "Find buffer" } )
