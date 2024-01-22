{ lib, vimPlugins, ... }:
with vimPlugins;
let
  opts = desc: { silent = "true"; noremap = "true"; inherit desc; };
in {
  neovim.plugins = {
    trouble = {
      package = trouble-nvim;
      dependencies = [ nvim-web-devicons ];
      cmd = [ "Trouble" "TroubleToggle" ];
      keys = [
        { lhs = "<leader>td"; rhs = ''<cmd>Trouble document_diagnostics<cr>''; opts = opts "Document diagnostics"; }
        { lhs = "<leader>td"; rhs = ''<cmd>Trouble workspace_diagnostics<cr>''; opts = opts "Workspace diagnostics"; }
        { lhs = "<leader>td"; rhs = ''<cmd>Trouble lsp_definitions<cr>''; opts = opts "LSP definitions"; }
        { lhs = "<leader>td"; rhs = ''<cmd>Trouble lsp_references<cr>''; opts = opts "LSP references"; }
        { lhs = "<leader>td"; rhs = ''<cmd>Trouble lsp_type_definitions<cr>''; opts = opts "LSP type definitions"; }
      ];
      config = "require('trouble').setup()";
    };
    todo-comments = {
      package = todo-comments-nvim;
      dependencies = [ plenary-nvim ];
      event = "InsertEnter";
      keys = [
        { lhs = "<leader>tt"; rhs = "<cmd>TodoTrouble<cr>"; opts = opts "Todo Trouble"; }
        { lhs = "<leader>tT"; rhs = "<cmd>TodoTelescope<cr>"; opts = opts "Todo Telescope"; }
      ];
      config = "require('todo-comments').setup()";
    };
  };
}
