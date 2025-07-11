return {
   {
    'saghen/blink.compat',
    -- use v2.* for blink.cmp v1.*
    version = '2.*',
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },
  {
    'saghen/blink.cmp',
    lazy = false,
    version = '1.*',
    dependencies = {
      { 'saecki/crates.nvim' },
    },
    opts = {
      completion = {
        menu = { border = 'single', auto_show = true },
        documentation = { window = { border = 'single' }, auto_show = true, auto_show_delay_ms = 200 },
      },
      signature = { window = { border = 'single' } },
      sources = {
        per_filetype = {
          toml = { inherit_defaults = 'true', 'crates' },
        },
        providers = {
          crates = {
            name = 'crates',
            module = 'blink.compat.source',
          },
        },
      },
      snippets = { preset = 'luasnip' },
      cmdline = {
        keymap = { preset = 'inherit' },
        completion = { menu = { auto_show = true } },
      },
    }
  },
}
