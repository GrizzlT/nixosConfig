return {
  {
    "zk-org/zk-nvim",
    tag = "v0.3.0",
    lazy = false,
    config = function()
      require("zk").setup({
        picker = "telescope",
      })
    end,
  },
}
