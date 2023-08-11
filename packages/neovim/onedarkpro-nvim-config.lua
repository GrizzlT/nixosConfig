require('onedarkpro').setup({
  -- write cached themes to $out
  cache_path = vim.env.out .. '/colors',
  cache_suffix = '.lua',
  -- disable plugins I won't use
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
  options = {
    transparency = true,
  }
})
