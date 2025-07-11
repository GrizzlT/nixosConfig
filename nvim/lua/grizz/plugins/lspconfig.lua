return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile', },
    dependencies = {
      'barreiroleo/ltex-extra.nvim',
      'folke/neodev.nvim',
      'b0o/schemastore.nvim',
    },
    config = function()
      vim.lsp.config('jsonls', {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true, },
          }
        }
      })
      vim.lsp.config('yamlls', {
        settings = {
          yaml = {
            schemaStore = {
              enable = false,
              url = "",
            },
            schemas = require('schemastore').yaml.schemas(),
          }
        }
      })

      vim.lsp.config('tinymist', {
        settings = {
          exportPdf = "onType",
          outputPath = "$root/target/$dir/$name",
        }
      })

      -- vim.lsp.config('pylsp', {
      --   settings = {
      --     pylsp = {
      --     }
      --   }
      -- })

      vim.lsp.config('lua_ls', {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
              path ~= vim.fn.stdpath('config')
              and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
            then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using (most
              -- likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
              -- Tell the language server how to find Lua modules same way as Neovim
              -- (see `:h lua-module-load`)
              path = {
                'lua/?.lua',
                'lua/?/init.lua',
              },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME
                -- Depending on the usage, you might want to add additional paths
                -- here.
                -- '${3rd}/luv/library'
                -- '${3rd}/busted/library'
              }
              -- Or pull in all of 'runtimepath'.
              -- NOTE: this is a lot slower and will cause issues when working on
              -- your own configuration.
              -- See https://github.com/neovim/nvim-lspconfig/issues/3189
              -- library = {
              --   vim.api.nvim_get_runtime_file('', true),
              -- }
            }
          })
        end,
        settings = {
          Lua = {}
        }
      })

      vim.lsp.enable('nil_ls')
      vim.lsp.enable('lua_ls')
      vim.lsp.enable('taplo')
      vim.lsp.enable('clangd')
      vim.lsp.enable('tinymist')
      vim.lsp.enable('openscad_lsp')
      vim.lsp.enable('jsonls')
      vim.lsp.enable('yamlls')
      vim.lsp.enable('pylsp')

        -- ts_ls = {
          -- init_options = {
          --   preferences = {
          --     includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
          --     includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          --     includeInlayVariableTypeHints = true,
          --     includeInlayFunctionParameterTypeHints = true,
          --     includeInlayVariableTypeHintsWhenTypeMatchesName = true,
          --     includeInlayPropertyDeclarationTypeHints = true,
          --     includeInlayFunctionLikeReturnTypeHints = true,
          --     includeInlayEnumMemberValueHints = true,
          --   }
          -- }
        -- },

      vim.diagnostic.config({
        severity_sort = true,
        float = { border = 'rounded' },
      })

      local function on_attach(client, bufnr)
        local opts = function(d)
          return {buffer = bufnr, remap = false, desc = d}
        end
        local telescope = require('telescope.builtin')

        if client ~= 'rust-analyzer' then
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts('Hover'))
        end

        if client ~= 'ltex' then
          vim.keymap.set("n", "gd", telescope.lsp_definitions, opts('Goto definition'))
        end
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts('Goto declaration'))
        vim.keymap.set("n", "go", telescope.lsp_type_definitions, opts('Goto type def'))
        vim.keymap.set("n", "gi", telescope.lsp_implementations, opts('Goto implementations'))
        vim.keymap.set("n", "<leader>lws", telescope.lsp_dynamic_workspace_symbols, opts('Workspace symbols'))
        vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts('Diagnostics Float'))
        vim.keymap.set("n", "<leader>lwd", telescope.diagnostics, opts('Workspace diagnostics'))
        vim.keymap.set("n", "<leader>ld", function () telescope.diagnostics({bufnr = bufnr}) end, opts('Document diagnostics'))
        vim.keymap.set("n", "<leader>lj", vim.diagnostic.goto_next, opts('Next diagnostic'))
        vim.keymap.set("n", "<leader>lk", vim.diagnostic.goto_prev, opts('Prev diagnostic'))
        vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts('Code action'))
        vim.keymap.set("n", "gr", telescope.lsp_references, opts('References'))
        vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts('Rename'))
        vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts('Signature help'))
        vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts('Signature help'))
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("buf_lsp_configuration", {}),
        desc = "Configure LSP for a buffer",
        callback = on_attach,
      })

      vim.lsp.inlay_hint.enable()
    end,
  },

  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    config = function()
      require('fidget').setup()
    end,
  },
}
