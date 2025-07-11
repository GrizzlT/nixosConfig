return {
  {
    'mrcjkb/rustaceanvim',
    version = '^6',
    lazy = false,
    ft = { 'rust' },
    config = function ()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function (_, bufnr)
            local desc = function(d)
              return {buffer = bufnr, remap = false, desc = d}
            end
            vim.keymap.set("n", "<leader>le", function() vim.cmd.RustLsp('runnables') end, desc('List runnables'))
            vim.keymap.set("n", "K", function() vim.cmd.RustLsp({ 'hover', 'actions' }) end, desc('Hover'))
            vim.keymap.set("n", "<leader>lc", function() vim.cmd.RustLsp('openCargo') end, desc('Open cargo.toml'))
            vim.keymap.set("n", "<leader>lp", function() vim.cmd.RustLsp('parentModule') end, desc('Goto parent module'))
            vim.keymap.set("n", "<leader>ls", function() vim.cmd.RustLsp('joinLines') end, desc('Join lines'))
            vim.keymap.set("n", "<leader>lR", function() vim.cmd.RustLsp('renderDiagnostic') end, desc('Render diagnostic'))
            vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, desc('Format buffer'))
          end
        },
      }
    end
  },

  {
    'saecki/crates.nvim',
    tag = 'stable',
    event = { "BufRead Cargo.toml" },
    config = function()
      require('crates').setup({
        completion = { cmp = { enabled = true, } },
        on_attach = function(bufnr)
          local crates = require('crates')
          local opts = function(d)
            if d ~= nil then
              return { buffer = bufnr, silent = true, remap = false, desc = d }
            else
              return { buffer = bufnr, silent = true, remap = false }
            end
          end

          vim.keymap.set('n', '<leader>ct', crates.toggle, opts('Toggle crates.nvim'))
          vim.keymap.set('n', '<leader>cr', crates.reload, opts('Reload crates.nvim'))

          vim.keymap.set('n', '<leader>cv', crates.show_versions_popup, opts('Show version popup'))
          vim.keymap.set('n', '<leader>cf', crates.show_features_popup, opts('Show features popup'))
          vim.keymap.set('n', '<leader>cd', crates.show_dependencies_popup, opts('Show dependencies popup'))

          vim.keymap.set('n', '<leader>cu', crates.update_crate, opts('Update crate'))
          vim.keymap.set('v', '<leader>cu', crates.update_crates, opts('Update crates'))
          vim.keymap.set('n', '<leader>ca', crates.update_all_crates, opts('Update all crates'))
          vim.keymap.set('n', '<leader>cU', crates.upgrade_crate, opts('Upgrade crate'))
          vim.keymap.set('v', '<leader>cU', crates.upgrade_crates, opts('Upgrade crates'))
          vim.keymap.set('n', '<leader>cA', crates.upgrade_all_crates, opts('Upgrade all crates'))

          vim.keymap.set('n', '<leader>ce', crates.expand_plain_crate_to_inline_table, opts('Expand to inline table'))
          vim.keymap.set('n', '<leader>cE', crates.extract_crate_into_table, opts('Extract to table'))

          vim.keymap.set('n', '<leader>cH', crates.open_homepage, opts('Open homepage'))
          vim.keymap.set('n', '<leader>cR', crates.open_repository, opts('Open repository'))
          vim.keymap.set('n', '<leader>cD', crates.open_documentation, opts('Open documentation'))
          vim.keymap.set('n', '<leader>cC', crates.open_crates_io, opts('Open on crates.io'))

          local function show_documentation()
            local filetype = vim.bo.filetype
            if vim.tbl_contains({ 'vim','help' }, filetype) then
              vim.cmd('h '..vim.fn.expand('<cword>'))
            elseif vim.tbl_contains({ 'man' }, filetype) then
              vim.cmd('Man '..vim.fn.expand('<cword>'))
            elseif vim.fn.expand('%:t') == 'Cargo.toml' and require('crates').popup_available() then
              require('crates').show_popup()
            else
              vim.lsp.buf.hover()
            end
          end

          vim.keymap.set('n', 'K', show_documentation, opts())
        end,
      })
    end,
  }
}
