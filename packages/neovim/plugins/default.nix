{ vimPlugins, vimExtraPlugins, buildVimPlugin, neovim-raw, runCommand, fetchFromGitHub }:
let
  hex-nvim = buildVimPlugin {
    pname = "hex-nvim";
    version = "2023-08-12";
    src = fetchFromGitHub {
      owner = "RaafatTurki";
      repo = "hex.nvim";
      rev = "63411ffe59fb8ecc3611367731cf13effc4d706f";
      sha256 = "TWP6TyC6KEKxSglG1bc3nZ5JOJitowkC9sOFi/1pzlk=";
    };
  };

  nvim-treesitter' = vimPlugins.nvim-treesitter.withPlugins (parsers:
    with parsers; [
      query toml lua rust gitcommit gitignore json markdown nix bash
    ]);

  onedarkpro = let
    neovim = neovim-raw.override {
      configure.packages.onedarkpro.start = [vimPlugins.onedarkpro-nvim];
    };
  in
    runCommand "onedarkpro-nvim" {} ''
      mkdir -p $out/lua/lualine/themes
      ${neovim}/bin/nvim -l ${../onedarkpro-nvim-config.lua}
      cd $out/colors
      rm cache
    '';

  silentNoRemap = ''silent = true, noremap = true'';
in with vimPlugins;
[
  # Colorscheme
  {
    plugin = onedarkpro;
    lazy = false;
    priority = 1000;
  }

  # Comments
  {
    plugin = comment-nvim;
    dependencies = [ nvim-ts-context-commentstring ];
    keys = [
      "gcc" "gco" "gcO" "gcb" "gcA" "gc"
      { lhs = "gc"; mode = "v"; } { lhs = "gb"; mode = "v"; }
    ];
  }

  # Telescope
  {
    plugin = telescope-nvim;
    dependencies = [ plenary-nvim ];
    cmd = "Telescope";
    keys = [
      { lhs = "<leader>pf"; rhs = ''function() require('telescope.builtin').find_files() end''; opts = ''desc = "Find file"''; }
      { lhs = "<leader>pp"; rhs = ''function() require('telescope.builtin').git_files() end''; opts = ''desc = "Git files"''; }
      { lhs = "<leader>pg"; rhs = ''function() require('telescope.builtin').live_grep() end''; opts = ''desc = "Live grep"''; }
      { lhs = "<leader>pb"; rhs = ''function() require('telescope.builtin').buffers() end''; opts = ''desc = "Find buffer"''; }
    ];
  }
  telescope-fzf-native-nvim
  telescope-ui-select-nvim

  # Trouble
  {
    plugin = trouble-nvim;
    dependencies = [ nvim-web-devicons ];
    cmd = [ "Trouble" "TroubleToggle" ];
    keys = [
      { lhs = "<leader>td"; rhs = ''"<cmd>Trouble document_diagnostics<cr>"''; opts = silentNoRemap; }
      { lhs = "<leader>td"; rhs = ''"<cmd>Trouble workspace_diagnostics<cr>"''; opts = silentNoRemap; }
      { lhs = "<leader>td"; rhs = ''"<cmd>Trouble lsp_definitions<cr>"''; opts = silentNoRemap; }
      { lhs = "<leader>td"; rhs = ''"<cmd>Trouble lsp_references<cr>"''; opts = silentNoRemap; }
      { lhs = "<leader>td"; rhs = ''"<cmd>Trouble lsp_type_definitions<cr>"''; opts = silentNoRemap; }
    ];
  }

  # Treesitter
  {
    plugin = nvim-treesitter';
    event = "BufRead";
  }
  {
    plugin = playground;
    cmd = "TSPlaygroundToggle";
  }
  nvim-ts-context-commentstring

  # LSP + completion
  {
    plugin = nvim-lspconfig;
    event = [ "BufReadPre" "BufNewFile" ];
    dependencies = [
      cmp-nvim-lsp
    ];
  }
  {
    plugin = nvim-cmp;
    event = "InsertEnter";
    dependencies = [
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp_luasnip
      lspkind-nvim
    ];
  }
  {
    plugin = luasnip;
    lazy = false;
  }

  # LuaLine
  {
    plugin = lualine-nvim;
    # lazy = false;
    event = "VeryLazy";
    dependencies = [ nvim-web-devicons ];
  }
  {
    plugin = vimExtraPlugins.lsp-progress-nvim;
    dependencies = [nvim-web-devicons];
  }

  # Autopairs
  {
    plugin = nvim-autopairs;
    event = "InsertEnter";
  }

  # Markdown previewing
  {
    plugin = markdown-preview-nvim;
    cmd = [ "MarkdownPreview" "MarkdownPreviewToggle" ];
  }

  # Hex editing
  {
    plugin = hex-nvim;
    cmd = [ "HexDump" "HexAssemble" "HexToggle" ];
  }

  # Colorscheme dev
  lush-nvim
]
