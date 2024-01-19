require('rust-tools').setup({
  server = {
    on_attach = function(_, bufnr)
      local desc = function(d)
        return {buffer = bufnr, remap = false, desc = d}
      end
      local rt = require('rust-tools')

      vim.keymap.set("n", "<leader>le", rt.runnables.runnables, desc('List runnables'))
      vim.keymap.set("n", "K", rt.hover_actions.hover_actions, desc('Hover'))
      vim.keymap.set("n", "<leader>lc", rt.open_cargo_toml.open_cargo_toml, desc('Open cargo.toml'))
      vim.keymap.set("n", "<leader>lp", rt.parent_module.parent_module, desc('Goto parent module'))
      vim.keymap.set("n", "<leader>ls", rt.join_lines.join_lines, desc('Join lines'))
      vim.keymap.set("n", "<leader>lR", rt.workspace_refresh.reload_workspace, desc('Reload cargo'))
      vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, desc('Format buffer'))
    end,
  },
})
