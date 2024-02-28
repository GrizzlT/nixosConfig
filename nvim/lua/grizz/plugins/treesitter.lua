return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring', },
    build = ":TSUpdate",
    event = "BufRead",
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = {
          "c", "lua", "vim", "vimdoc", "query", "toml", "rust", "json", "markdown",
          "nix", "bash", "fish", "typescript", "javascript", "gitcommit", "gitignore", "typst", "ledger",
        },
        sync_install = false,
        highlight = {
          enable = true,
          disable = function(lang, buf)
              local max_filesize = 200 * 1024 -- 100 KB
              local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
              if ok and stats and stats.size > max_filesize then
                  return true
              end
          end,
        },
        indent = { enable = false, },
        auto_install = true,
      })
      require('ts_context_commentstring').setup {
        enable_autocmd = false,
      }
    end,
  },
}
