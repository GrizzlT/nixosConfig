local cmp = require('cmp')
local mapping = cmp.mapping
local luasnip = require('luasnip')

local completion_menu_map = {
  luasnip = "[Snip]",
  nvim_lsp = "[LSP]",
  buffer = "[Buf]",
  cmdline = "[Cmd]",
}

local function format_vim_entry(entry, vim_item)
  vim_item.menu = completion_menu_map[entry.source.name] or string.format("[%s]", entry.source.name)
  return vim_item
end

local function get_bufnrs()
  local max_buf_size = 1000
  local result = {}
  local cur_buf = vim.api.nvim_get_current_buf()
  local all_bufs = vim.api.nvim_list_bufs()
  for i = 1, #all_bufs do
    local buf = all_bufs[i]
    if vim.api.nvim_buf_get_option(buf, "buflisted")
      and vim.api.nvim_buf_get_option(buf, "buftype") == ""
      and vim.api.nvim_buf_line_count(buf) <= max_buf_size
    or buf == cur_buf then
      table.insert(result, buf)
    end
  end
  return result
end

cmp.setup({
  snippet = {
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'luasnip', keyword_length = 2, },
      { name = 'path' },
      {
        name = 'buffer',
        option = {
          get_bufnrs = get_bufnrs
        }
      },
    }),
    expand = function (args)
      luasnip.lsp_expand(args.body)
    end,
    mapping = mapping.preset.insert({
      ["<C-y>"] = mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
      ["<M-y>"] = mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
      ["<M-d>"] = mapping.scroll_docs(8),
      ["<M-u>"] = mapping.scroll_docs(-8),
    }),
    formatting = {
      format = format_vim_entry,
    },
  }
})
