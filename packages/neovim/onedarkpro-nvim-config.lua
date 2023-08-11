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
  -- options = {
  --   transparency = true,
  -- }
})

for _, flavor in ipairs({ 'onedark', 'onedark_dark', 'onedark_vivid', 'onelight' }) do
  local lualine_theme = require('lualine.themes.' .. flavor)

  local resolved_theme = 'local onedarkpro = {\n' ..
    'normal = {\n' ..
    'a = { bg = \'' .. lualine_theme.normal.a.bg .. '\', fg = \'' .. lualine_theme.normal.a.fg .. '\'},\n' ..
    'b = { bg = \'' .. lualine_theme.normal.b.bg .. '\', fg = \'' .. lualine_theme.normal.b.fg .. '\'},\n' ..
    'c = { bg = \'' .. lualine_theme.normal.c.bg .. '\', fg = \'' .. lualine_theme.normal.c.fg .. '\'},\n' ..
    '},\n' ..
    'insert = {\n' ..
    'a = { bg = \'' .. lualine_theme.insert.a.bg .. '\', fg = \'' .. lualine_theme.insert.a.fg .. '\'},\n' ..
    'b = { bg = \'' .. lualine_theme.insert.b.bg .. '\', fg = \'' .. lualine_theme.insert.b.fg .. '\'},\n' ..
    '},\n' ..
    'command = {\n' ..
    'a = { bg = \'' .. lualine_theme.command.a.bg .. '\', fg = \'' .. lualine_theme.command.a.fg .. '\'},\n' ..
    'b = { bg = \'' .. lualine_theme.command.b.bg .. '\', fg = \'' .. lualine_theme.command.b.fg .. '\'},\n' ..
    '},\n' ..
    'visual = {\n' ..
    'a = { bg = \'' .. lualine_theme.visual.a.bg .. '\', fg = \'' .. lualine_theme.visual.a.fg .. '\'},\n' ..
    'b = { bg = \'' .. lualine_theme.visual.b.bg .. '\', fg = \'' .. lualine_theme.visual.b.fg .. '\'},\n' ..
    '},\n' ..
    'replace = {\n' ..
    'a = { bg = \'' .. lualine_theme.replace.a.bg .. '\', fg = \'' .. lualine_theme.replace.a.fg .. '\'},\n' ..
    'b = { bg = \'' .. lualine_theme.replace.b.bg .. '\', fg = \'' .. lualine_theme.replace.b.fg .. '\'},\n' ..
    '},\n' ..
    'inactive = {\n' ..
    'a = { bg = \'' .. lualine_theme.inactive.a.bg .. '\', fg = \'' .. lualine_theme.inactive.a.fg .. '\'},\n' ..
    'b = { bg = \'' .. lualine_theme.inactive.b.bg .. '\', fg = \'' .. lualine_theme.inactive.b.fg .. '\'},\n' ..
    'c = { bg = \'' .. lualine_theme.inactive.c.bg .. '\', fg = \'' .. lualine_theme.inactive.c.fg .. '\'},\n' ..
    '}\n}\nreturn onedarkpro'

  local chunk = assert(loadstring(resolved_theme))
  local out = assert(io.open(vim.env.out .. '/lua/lualine/themes/' .. flavor .. '.lua','wb'))
  assert(out:write(string.dump(chunk)))
  out:close()
end
