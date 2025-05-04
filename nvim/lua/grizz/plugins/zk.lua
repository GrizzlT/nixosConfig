return {
  {
    "zk-org/zk-nvim",
    config = function()
      require("zk").setup({
        picker = "telescope",
      })
    end,
  },
}
