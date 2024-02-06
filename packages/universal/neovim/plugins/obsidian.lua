require('obsidian').setup({
  mappings = {
    ["gd"] = {
      action = require('obsidian').util.gf_passthrough,
      opts = { noremap = false, expr = true, buffer = true, desc = 'Follow Obsidian Link' },
    },
    ["<leader>ch"] = {
      action = require('obsidian').util.toggle_checkbox,
      opts = { buffer = true, desc = 'Toggle checkbox' },
    },
    ["<leader>on"] = {
      action = '<cmd>ObsidianQuickSwitch<cr>',
      opts = { buffer = true, desc = 'Quick switch' },
    },
    ["<leader>ot"] = {
      action = '<cmd>ObsidianTemplate<cr>',
      opts = { buffer = true, desc = 'Create from Template' },
    }
  },
  workspaces = {
    {
      name = "personal",
      path = "~/DATA/02_Informational/Obsidian/Personal",
    },
    {
      name = "projects",
      path = "~/DATA/02_Informational/Obsidian/Projects",
    },
  },
})
