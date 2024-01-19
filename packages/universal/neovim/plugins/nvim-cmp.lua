local cmp = require('cmp')
local mapping = cmp.mapping
local luasnip = require('luasnip')
local lspkind = require('lspkind')

cmp.setup({
  sources = cmp.config.sources({
    { name = 'crates' },
    { name = 'hledger' },
  }, {
    { name = 'nvim_lsp' },
    { name = 'luasnip', keyword_length = 2, },
    { name = 'path' },
    { name = 'buffer' },
  }),
  snippet = {
    expand = function (args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<C-n>"] = mapping(function ()
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior })
      else
        cmp.complete()
      end
    end),
    ["<C-p>"] = mapping(function ()
      if cmp.visible then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior })
      else
        cmp.complete()
      end
    end),
    ["<C-e>"] = mapping.abort(),
    ["<C-y>"] = mapping(mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })),
    ["<M-y>"] = mapping(mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert })),
    ["<M-d>"] = mapping(mapping.scroll_docs(8)),
    ["<M-u>"] = mapping(mapping.scroll_docs(-8)),
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol',
      menu = ({
        buffer = "[Buf]",
        nvim_lsp = "[LSP]",
        luasnip = "[Snip]",
        cmdline = "[Cmd]",
        path = "[Path]",
      })
    }),
  },
})
