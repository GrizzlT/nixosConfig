return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring', },
    build = ":TSUpdate",
      -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

      -- "c", "lua", "vim", "vimdoc", "query", "toml", "rust", "json", "markdown",
      -- "nix", "bash", "fish", "typescript", "javascript", "gitcommit", "gitignore", "typst", "ledger",
  },
}
