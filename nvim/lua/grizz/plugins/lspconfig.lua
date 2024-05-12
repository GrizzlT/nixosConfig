return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile', },
    dependencies = {
      'barreiroleo/ltex-extra.nvim',
      'hrsh7th/cmp-nvim-lsp',
      'folke/neodev.nvim',
    },
    config = function()
      local lspconfig = require('lspconfig')

      local lsp_capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      local servers = {
        nil_ls = {},
        lua_ls = {},
        taplo = {},
        -- ccls = { init_options = { compilationDatabaseDirectory = "build"; } },
        -- ccls = { },
        clangd = {},
        -- digestif = {},
        ltex = {
          on_attach = function(client, bufnr)
            require("ltex_extra").setup({
              load_langs = { "en-US", "en-GB", "nl-BE" },
              path = ".ltex-data/",
            })
          end,
          autostart = false,
        },
        typst_lsp = {
          settings = {
            exportPdf = "onSave" -- Choose onType, onSave or never.
          },
        },
        tsserver = {},
        pylsp = {
          plugins = {
            -- formatter options
            black = { enabled = true },
            autopep8 = { enabled = false },
            yapf = { enabled = false },
            -- linter options
            pylint = { enabled = true, executable = "pylint" },
            pyflakes = { enabled = false },
            pycodestyle = { enabled = false },
            -- type checker
            pylsp_mypy = { enabled = true },
            -- auto-completion options
            jedi_completion = { fuzzy = true },
            -- import sorting
            pyls_isort = { enabled = true },
        },
        }
      }

      for server_name, config in pairs(servers) do
        lspconfig[server_name].setup(vim.tbl_deep_extend(
          "force",
          { capabilities = lsp_capabilities },
          config
        ))
      end

      vim.diagnostic.config({
        severity_sort = true,
        float = {border = 'rounded'},
      })

      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
        vim.lsp.handlers.hover,
        {border = 'rounded'}
      )

      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        {border = 'rounded'}
      )

      local function on_attach(client, bufnr)
        local opts = function(d)
          return {buffer = bufnr, remap = false, desc = d}
        end
        local telescope = require('telescope.builtin')

        if client ~= 'rust-analyzer' then
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts('Hover'))
        -- else if client == 'tsserver' then
        --   vim.api.nvim_create_autocmd('FormatOnSave', {
        --     buffer = bufnr,
        --     callback = vim.lsp.buf.format
        --   })
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
