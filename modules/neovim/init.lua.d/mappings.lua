vim.g.mapleader = ","
vim.g.maplocalleader=';'

vim.keymap.set("n", "<c-a>", "gg<S-v>G", {desc = "Select all"})

-- move lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {desc = "Move selection down"})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {desc = "Move selection up"})
-- better up/down
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- vim.keymap.set("n", "J", "mzJ`z", {desc = "Join next line"})
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader><leader>p", "\"_dP", {desc = "Void paste"})

-- next greatest remap ever
vim.keymap.set({"n", "v"}, "<leader>y", "\"+y", {desc = "Yank to system"})
vim.keymap.set("n", "<leader>Y", "\"+Y", {desc = "Yank line to system"})

vim.keymap.set({"n", "v"}, "<leader><leader>d", "\"_d", {desc = "Void delete"})

vim.keymap.set("n", "Q", "<nop>")

-- vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {desc = "Substitute word"})
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make executable" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to down window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to up window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<S-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<S-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<S-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<S-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- vim.keymap.set({"i", "s"}, "<C-_>", function() require('luasnip').jump(-1) end, { remap = false, desc = "Jump backwards" })
-- vim.keymap.set({"i", "s"}, "<C-M>", function() require('luasnip').expand_or_jump() end, { remap  = false, desc = "Jump forward" })
-- vim.keymap.set({"i", "s"}, "<C-t>t", '<cmd>lua require("grizz.luasnip-helpers").dynamic_node_external_update(1)<Cr>', {noremap = true, desc = "Luasnip 1"})
-- vim.keymap.set({"i", "s"}, "<C-t>g", '<cmd>lua require("grizz.luasnip-helpers").dynamic_node_external_update(2)<Cr>', {noremap = true, desc = "Luasnip 2"})
-- vim.keymap.set({"i", "s"}, "<C-g>g", '<cmd>lua require("grizz.luasnip-helpers").dynamic_node_external_update(1)<Cr>', {noremap = true, desc = "Luasnip 3"})
-- vim.keymap.set({"i", "s"}, "<C-g>t", '<cmd>lua require("grizz.luasnip-helpers").dynamic_node_external_update(2)<Cr>', {noremap = true, desc = "Luasnip 4"})

