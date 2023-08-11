-- require('lsp-progress').setup({
--   spinner = {
--     "[    ]",
--     "[=   ]",
--     "[==  ]",
--     "[=== ]",
--     "[ ===]",
--     "[  ==]",
--     "[   =]",
--     "[    ]",
--     "[   =]",
--     "[  ==]",
--     "[ ===]",
--     "[====]",
--     "[=== ]",
--     "[==  ]",
--     "[=   ]", },
--   spin_update_time = 60;
-- })

require('lualine').setup({
  options = {
    theme = require('lualine.themes.onedark'),
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'searchcount' },
    lualine_z = { 'location' },
  }
})
