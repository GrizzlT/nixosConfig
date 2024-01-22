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
