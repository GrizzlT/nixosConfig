{ vimPlugins, vimExtraPlugins, buildVimPlugin, neovim-raw, runCommand, fetchFromGitHub, fetchgit, tree-sitter }:
let
  d2-vim = buildVimPlugin {
    pname = "d2-vim";
    version = "0.0.0+rev=981c87d";
    src = fetchFromGitHub {
      owner = "terrastruct";
      repo = "d2-vim";
      rev = "981c87dccb63df2887cc41b96e84bf550f736c57";
      sha256 = "+mT4pEbtq7f9ZXhOop3Jnjr7ulxU32VtahffIwQqYF4=";
    };
  };
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
  tree-sitter-d2 = tree-sitter.buildGrammar {
    language = "d2";
    version = "0.0.0+rev=e7507ddd";
    src = fetchgit {
      url = "https://git.pleshevski.ru/pleshevskiy/tree-sitter-d2";
      rev = "e7507ddd983427cb71b4bd96b039c382c73d65c5";
      hash = "sha256-m7ZCxnW4Q1bQp1GhntUF7l+p6DV1p/2AJXhVeRy8Rec=";
    };
  };
  tree-sitter-typst = tree-sitter.buildGrammar {
    language = "typst";
    version = "0.0.0+rev=8e00691"; # 7b90a3615356a36cf1c8d00cb3e0211f2";
    src = fetchFromGitHub {
      owner = "uben0";
      repo = "tree-sitter-typst";
      rev = "8e006917b90a3615356a36cf1c8d00cb3e0211f2";
      sha256 = "Xex0BDBpWwU6Tit19WtwU6zt94GuJtNnw81YHEa8YOs=";
    };
  };

  nvim-treesitter' = vimPlugins.nvim-treesitter.withPlugins (parsers:
    with parsers; [
      query toml lua rust gitcommit gitignore json markdown nix bash typescript
      tree-sitter-d2 tree-sitter-typst
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

  # Smart splits
  {
    plugin = smart-splits-nvim;
    lazy = false;
  }
  {
    plugin = oil-nvim;
    dependencies = [nvim-web-devicons];
    keys = [
      { lhs = "<leader>-"; rhs = "'<cmd>Oil<cr>'"; opts = ''desc = "Open file explorer"''; }
    ];
  }

  # Telescope
  {
    plugin = telescope-nvim;
    dependencies = [ plenary-nvim ];
    cmd = "Telescope";
    keys = [
      { lhs = "<leader>pf"; rhs = ''function() require('telescope.builtin').find_files({no_ignore = true}) end''; opts = ''desc = "Find file"''; }
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

  # Todo comments
  {
    plugin = todo-comments-nvim;
    dependencies = [plenary-nvim];
    event = "InsertEnter";
    keys = [
      { lhs = "<leader>tt"; rhs = "'<cmd>TodoTrouble<cr>'"; opts = silentNoRemap; }
      { lhs = "<leader>tT"; rhs = "'<cmd>TodoTelescope<cr>'"; opts = silentNoRemap; }
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
  {
    plugin = vimExtraPlugins.typst-vim;
    lazy = false;
  }

  # LSP + completion
  {
    plugin = nvim-lspconfig;
    event = [ "BufReadPre" "BufNewFile" ];
    dependencies = [
      cmp-nvim-lsp
      vimExtraPlugins.ltex-extra-nvim
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
  vimExtraPlugins.fidget-nvim

  {
    plugin = vimExtraPlugins.rust-tools-nvim;
    ft = "rust";
    dependencies = [ nvim-lspconfig ];
  }

  # {
  #   plugin = vimExtraPlugins.nvim-ghost-nvim;
  #   lazy = false;
  # }

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

  # Ltex-ls
  vimExtraPlugins.ltex-extra-nvim

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
  {
    plugin = d2-vim;
    ft = "d2";
  }

  # Colorscheme dev
  lush-nvim
]
