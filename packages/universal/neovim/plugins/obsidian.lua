require('obsidian').setup({
  mappings = {
    ["gd"] = {
      action = function()
        return require('obsidian').util.gf_passthrough()
      end,
      opts = { noremap = false, expr = true, buffer = true },
    },
    ["<leader>ch"] = {
      action = function()
        return require('obsidian').util.toggle_checkbox()
      end,
      opts = { buffer = true },
    },
  },
})
