{ pkgs, lib, vimPlugins, ... }:
with vimPlugins;
let
  opts = desc: { silent = "true"; noremap = "true"; inherit desc; };
  hex-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "hex-nvim";
    version = "2023-08-12";
    src = pkgs.fetchFromGitHub {
      owner = "RaafatTurki";
      repo = "hex.nvim";
      rev = "63411ffe59fb8ecc3611367731cf13effc4d706f";
      sha256 = "TWP6TyC6KEKxSglG1bc3nZ5JOJitowkC9sOFi/1pzlk=";
    };
  };
in {
  neovim.plugins = {
    comment = {
      package = comment-nvim;
      dependencies = [ nvim-ts-context-commentstring ];
      keys = [
        "gcc" "gco" "gcO" "gcb" "gcA" "gc"
        { lhs = "gc"; mode = ["v"]; } { lhs = "gb"; mode = ["v"]; }
      ];
      config = lib.fileContents ./comment.lua;
    };
    smart-splits = {
      package = smart-splits-nvim;
      lazy = false;
      config = lib.fileContents ./smart-splits-nvim.lua;
    };
    oil = {
      package = oil-nvim;
      dependencies = [ nvim-web-devicons ];
      keys = [
        { lhs = "<leader>-"; rhs = "<cmd>Oil<cr>"; opts = opts "Open file explorer"; }
      ];
      config = "require('oil').setup()";
    };
    autopairs = {
      package = nvim-autopairs;
      event = "InsertEnter";
      config = lib.fileContents ./autopairs.lua;
    };

    markdown-preview = {
      package = markdown-preview-nvim;
      cmd = [ "MarkdownPreview" "MarkdownPreviewToggle" ];
      ft = "markdown";
    };
    hex = {
      package = hex-nvim;
      cmd = [ "HexDump" "HexAssemble" "HexToggle" ];
      config = "require('hex').setup()";
      extraBinaries = with pkgs; [ unixtools.xxd ];
    };
  };
}
