return {
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("onedarkpro").setup({
        plugins = {
          aerial = false,
          barbar = false,
          copilot = false,
          dashboard = false,
          hop = false,
          leap = false,
          mini_indentscope = false,
          neo_tree = false,
          nvim_tree = false,
          packer = false,
        },
      })
    end,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = true,
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato",
      })
    end,
  },
}
