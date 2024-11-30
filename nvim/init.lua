require("grizz.autocommands")
require("grizz.mappings")
require("grizz.options")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("grizz.plugins", {
  defaults = {
    lazy = true,
  },
  change_detection = {
    enabled = false;
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        -- 'netrwPlugin',
        'tarPlugin',
        'spellfile',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})

vim.cmd("colorscheme onedark")
