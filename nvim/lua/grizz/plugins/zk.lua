return {
  {
    "zk-org/zk-nvim",
    lazy = false,
    config = function()
      require("zk").setup({
        picker = "telescope",
      })
    end,
  },
}
