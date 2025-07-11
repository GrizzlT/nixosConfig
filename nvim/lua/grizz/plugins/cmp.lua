return {
  {
    'saghen/blink.cmp',
    lazy = false,
    version = '1.*',
    opts = {
      completion = {
        menu = { border = 'single' },
        documentation = { window = { border = 'single' } },
      },
      signature = { window = { border = 'single' } },
      sources = {
        per_filetype = {
          toml = { inherit_defaults = 'true', 'crates' },
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
