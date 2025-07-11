local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local GrizzGroup = augroup('Grizz', {})
local yank_group = augroup('HighlightYank', {})

autocmd('FileType', {
  pattern = { 'rust', 'javascript', 'toml', 'c', 'python', 'typescript', 'nix', 'lua', 'gitcommit', 'gitignore', 'Dockerfile', 'typst', 'yaml' },
  callback = function ()
    vim.treesitter.start()
    vim.o.winborder = 'rounded'
  end
})

vim.api.nvim_create_autocmd("User", {
  pattern = "TelescopeFindPre",
  callback = function()
    vim.opt_local.winborder = "none"
    vim.api.nvim_create_autocmd("WinLeave", {
      once = true,
      callback = function()
        vim.opt_local.winborder = "rounded"
      end,
    })
  end,
})

autocmd('TextYankPost', {
  group = yank_group,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

autocmd({"BufRead", "BufNewFile"}, {
  group = GrizzGroup,
  pattern = "/dev/shm/*",
  callback = function()
    vim.opt.undofile = false
    vim.opt.backup = false
    vim.opt.writebackup = false
    vim.opt.swapfile = false
  end,
})

autocmd({"BufWritePre"}, {
  group = GrizzGroup,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

autocmd("BufWritePre", {
  group = GrizzGroup,
  pattern = { "/tmp/*", "COMMIT_EDITMSG", "MERGE_MSG", "*.tmp", "*.bak", "/private/*", "/dev/shm/*"},
  callback = function()
    vim.opt_local.undofile = false
  end,
})

