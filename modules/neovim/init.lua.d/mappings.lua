vim.g.mapleader = ","
vim.g.maplocalleader=';'

local map = vim.keymap.set

map({ "n", "x" }, "<leader>", "<nop>")

-- emacs-like mappings
map("!", "<C-d>", "<left>")
map("!", "<C-f>", "<right>")
map("!", "<M-d>", "<C-left>")
map("!", "<M-f>", "<C-right>")
map("i", "<C-n>", "<down>")
map("i", "<C-p>", "<up>")
map("!", "<M-BS>", "<C-w>")
map("c", "<C-a>", "<C-b>")

-- New lines in insert mode
map("i", "<M-n>", "<C-o>o")
map("i", "<M-p>", "<C-o>O")

-- Make j/k movement a jump if count > 5
map("n", "j", [[(v:count1 > 5 ? "m'"..v:count : '') .. 'j']], { expr = true })
map("n", "k", [[(v:count1 > 5 ? "m'"..v:count : '') .. 'k']], { expr = true })

-- Clear search hl by pressing Esc
map("n", "<Esc>", "<Cmd>nohlsearch<CR>")

-- move lines
map("v", "J", ":m '>+1<CR>gv=gv", {desc = "Move selection down"})
map("v", "K", ":m '<-2<CR>gv=gv", {desc = "Move selection up"})
-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- map("n", "J", "mzJ`z", {desc = "Join next line"})
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- greatest remap ever
map("x", "<leader><leader>p", "\"_dP", {desc = "Void paste"})

-- next greatest remap ever
map({"n", "v"}, "<leader>y", "\"+y", {desc = "Yank to system"})
map("n", "<leader>Y", "\"+Y", {desc = "Yank line to system"})

map({"n", "v"}, "<leader><leader>d", "\"_d", {desc = "Void delete"})

map("n", "Q", "<nop>")

map("n", "<M-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<M-j>", "<C-w>j", { desc = "Go to down window" })
map("n", "<M-k>", "<C-w>k", { desc = "Go to up window" })
map("n", "<M-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize window using <ctrl> arrow keys
map("n", "<S-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<S-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<S-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<S-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- map({"i", "s"}, "<C-_>", function() require('luasnip').jump(-1) end, { remap = false, desc = "Jump backwards" })
-- map({"i", "s"}, "<C-M>", function() require('luasnip').expand_or_jump() end, { remap  = false, desc = "Jump forward" })
-- map({"i", "s"}, "<C-t>t", '<cmd>lua require("grizz.luasnip-helpers").dynamic_node_external_update(1)<Cr>', {noremap = true, desc = "Luasnip 1"})
-- map({"i", "s"}, "<C-t>g", '<cmd>lua require("grizz.luasnip-helpers").dynamic_node_external_update(2)<Cr>', {noremap = true, desc = "Luasnip 2"})
-- map({"i", "s"}, "<C-g>g", '<cmd>lua require("grizz.luasnip-helpers").dynamic_node_external_update(1)<Cr>', {noremap = true, desc = "Luasnip 3"})
-- map({"i", "s"}, "<C-g>t", '<cmd>lua require("grizz.luasnip-helpers").dynamic_node_external_update(2)<Cr>', {noremap = true, desc = "Luasnip 4"})

