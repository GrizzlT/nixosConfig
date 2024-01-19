local ghostUserCommandsGroup = vim.api.nvim_create_augroup('GhostText user commands', { clear = true })

vim.api.nvim_create_autocmd('User', {
  pattern = "*github.com",
  callback = function()
    vim.opt.filetype = 'markdown'
  end,
  group = ghostUserCommandsGroup,
})
