require('trouble').setup {}

local opts = {silent = true, noremap = true}
vim.keymap.set('n', '<leader>td', "<cmd>Trouble document_diagnostics<cr>", opts)
vim.keymap.set('n', '<leader>tw', "<cmd>Trouble workspace_diagnostics<cr>", opts)
vim.keymap.set('n', '<leader>tD', "<cmd>Trouble lsp_definitions<cr>", opts)
vim.keymap.set('n', '<leader>tr', "<cmd>Trouble lsp_references<cr>", opts)
vim.keymap.set('n', '<leader>to', "<cmd>Trouble lsp_type_definitions<cr>", opts)
