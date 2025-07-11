-- Default indentation settings
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = -1
vim.opt.expandtab = true

-- Options
vim.opt.termguicolors = true
vim.opt.mouse = ""
vim.opt.showmode = false
vim.opt.completeopt = "menu,menuone,noinsert"
vim.opt.virtualedit = "block"

-- Backup
vim.opt.backupcopy = 'yes'
vim.opt.backup = false
vim.opt.writebackup = true
vim.opt.undofile = true

-- Make <Esc> faster
vim.opt.ttimeoutlen = 15
vim.opt.timeoutlen = 500

-- Don't redraw when executing macros
vim.opt.lazyredraw = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
-- vim.opt.hlsearch = false

-- Gutter settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80,120"

-- wrap
vim.opt.wrap = false
vim.opt.breakindent = true

-- Splitting
vim.opt.splitright = true
vim.opt.splitbelow = true

-- context
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5

-- Fire CursorHold event faster
vim.opt.updatetime = 700

vim.opt.list = true
vim.opt.listchars = "tab:󰌒 ,trail:⋅,precedes:❬,extends:❭"
vim.opt.conceallevel = 1

-- don't show trailing spaces during insert mode
local listchars_update = vim.api.nvim_create_augroup('listchars_update', {})
vim.api.nvim_create_autocmd("InsertEnter", {
  group = listchars_update,
  pattern = "*",
  command = 'setlocal listchars="tab:󰌒 ,extends:❭,precedes:❬"'
})
vim.api.nvim_create_autocmd("InsertLeave", {
  group = listchars_update,
  pattern = "*",
  command = 'setlocal listchars="tab:󰌒 ,trail:⋅,precedes:❬,extends:❭"'
})

