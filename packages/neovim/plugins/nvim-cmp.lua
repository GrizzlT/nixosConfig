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

cmp.setup({
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  snippet = {
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'luasnip', keyword_length = 2, },
      { name = 'path' },
      { name = 'buffer' },
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
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    formatting = {
      format = format_vim_entry,
    },
  }
})
