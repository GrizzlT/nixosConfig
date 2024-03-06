return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'kirasok/cmp-hledger',
      'onsails/lspkind.nvim',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require('cmp')
      local mapping = cmp.mapping

      cmp.setup({
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip', keyword_length = 2, },
        }, {
          { name = 'path' },
          { name = 'buffer' },
        }),
        snippet = {
          expand = function (args)
            require('luasnip').lsp_expand(args.body)
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
            if cmp.visible() then
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
          format = require('lspkind').cmp_format({
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

      cmp.setup.filetype('toml', {
        sources = cmp.config.sources({
          { name = 'crates' },
        }, {
          { name = 'path' },
          { name = 'buffer' },
        })
      })
      cmp.setup.filetype({ 'ledger', 'hledger' }, {
        sources = cmp.config.sources({
          { name = 'hledger' },
        }, {
          { name = 'path' },
          { name = 'buffer' },
        })
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline', keyword_length = 3, }
        })
      })
    end,
  },
}
