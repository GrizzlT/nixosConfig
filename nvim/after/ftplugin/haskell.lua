-- ~/.config/nvim/after/ftplugin/haskell.lua
local ht = require('haskell-tools')
local bufnr = vim.api.nvim_get_current_buf()
local opts = { noremap = true, silent = true, buffer = bufnr, }
-- Hoogle search for the type signature of the definition under the cursor
vim.keymap.set('n', '<leader>ls', ht.hoogle.hoogle_signature, opts)
