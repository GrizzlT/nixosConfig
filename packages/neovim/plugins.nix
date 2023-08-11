{ vimPlugins }:
let
  nvim-treesitter' = vimPlugins.nvim-treesitter.withPlugins (parsers:
    with parsers; [
      query toml lua rust gitcommit gitignore json markdown nix bash
    ]);
in with vimPlugins;
[
  # Colorscheme
  {
    plugin = onedarkpro-nvim;
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

  # Colorscheme dev
  lush-nvim
]
