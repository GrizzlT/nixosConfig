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
      vim.cmd("colorscheme onedark")
    end,
  },
}
