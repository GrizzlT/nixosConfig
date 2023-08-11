require('lsp-progress').setup({
  spinner = {
    "[    ]",
    "[=   ]",
    "[==  ]",
    "[=== ]",
    "[ ===]",
    "[  ==]",
    "[   =]",
    "[    ]",
    "[   =]",
    "[  ==]",
    "[ ===]",
    "[====]",
    "[=== ]",
    "[==  ]",
    "[=   ]", },
  spin_update_time = 60;
})

require('lualine').setup({
  options = {
    theme = require('lualine.themes.onedark'),
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { "require('lsp-progress').progress()" },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'filename' },
    lualine_z = { 'location' },
  }
})

-- listen lsp-progress event and refresh lualine
vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User LspProgressStatusUpdated", {
    group = "lualine_augroup",
    callback = require("lualine").refresh,
})
