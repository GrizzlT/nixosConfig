return {
  {
    'L3MON4D3/LuaSnip',
    version = "v2.*",
    event = "InsertEnter",
    build = "make install_jsregexp",
    config = function()
      local luasnip = require('luasnip')

      luasnip.config.set_config({
        history = true,
        region_check_events = 'InsertEnter',
        delete_check_events = nil,
        update_events = {'TextChanged','TextChangedI', 'InsertLeave'},
        store_selection_keys = "<Tab>",
        enable_autosnippets = true,
      })

      vim.keymap.set({"i", "s"}, "<C-B>", function() if require('luasnip').choice_active() then require('luasnip').change_choice(1) end end, { remap = false, desc = "Next choice"})
      vim.keymap.set({ "i", "s" }, "<C-k>", luasnip.expand, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-f>", function() luasnip.jump(1) end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-v>", function() luasnip.jump(-1) end, { silent = true })

      require('luasnip.loaders.from_lua').lazy_load({
        paths = "~/.config/nvim/luasnippets",
      })
    end,
  },
}
