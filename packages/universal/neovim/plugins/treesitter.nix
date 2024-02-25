{ pkgs, lib, vimPlugins, ... }: let
  tree-sitter-d2 = pkgs.tree-sitter.buildGrammar {
    language = "d2";
    version = "0.0.0+rev=e7507ddd";
    src = pkgs.fetchgit {
      url = "https://git.pleshevski.ru/pleshevskiy/tree-sitter-d2";
      rev = "e7507ddd983427cb71b4bd96b039c382c73d65c5";
      hash = "sha256-m7ZCxnW4Q1bQp1GhntUF7l+p6DV1p/2AJXhVeRy8Rec=";
    };
  };
  tree-sitter-typst = pkgs.tree-sitter.buildGrammar {
    language = "typst";
    version = "0.0.0+rev=8e00691"; # 7b90a3615356a36cf1c8d00cb3e0211f2";
    src = pkgs.fetchFromGitHub {
      owner = "uben0";
      repo = "tree-sitter-typst";
      rev = "8e006917b90a3615356a36cf1c8d00cb3e0211f2";
      sha256 = "Xex0BDBpWwU6Tit19WtwU6zt94GuJtNnw81YHEa8YOs=";
    };
  };

  # use vimPlugins from pkgs for withPlugin behavior
  nvim-treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (p:
    with p; [
      toml lua rust json markdown nix bash typescript c
      gitcommit gitignore
      tree-sitter-d2 tree-sitter-typst
      ledger query
    ]);
in {
  neovim.plugins = {
    treesitter = {
      package = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
      event = "BufRead";
      config = lib.fileContents ./treesitter.lua;
    };
    ts-playground = {
      package = vimPlugins.playground;
      cmd = "TSPlaygroundToggle";
    };
    ts-ctx-commentstr.package = vimPlugins.nvim-ts-context-commentstring;
  };
}
