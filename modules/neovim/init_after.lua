local GrizzGroup = vim.api.nvim_create_augroup('Grizz', {})

-- Highlight a selection on Yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_on_yank", {}),
  callback = function ()
    vim.highlight.on_yank({
      timeout = 40,
    })
  end
})

vim.api.nvim_create_autocmd({"BufWritePre"}, {
  group = GrizzGroup,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = GrizzGroup,
  pattern = { "/tmp/*", "COMMIT_EDITMSG", "MERGE_MSG", "*.tmp", "*.bak", "/private/*", },
  callback = function()
    vim.opt_local.undofile = false
    vim.opt_local.writebackup = false
    vim.opt_local.backup = false
    vim.opt_local.swapfile = false
  end,
})

