{ pkgs, lib, vimPlugins, ... }:
with vimPlugins;
let
  cmp-hledger = pkgs.vimUtils.buildVimPlugin {
    pname = "cmp-hledger";
    version = "0.0.0+rev=1d237ed";
    src = pkgs.fetchFromGitHub {
      owner = "kirasok";
      repo = "cmp-hledger";
      rev = "1d237ed9f5b8748348d600741ef15653050023fb";
      sha256 = "5P6PsCop8wFdFkCPpShAoCj1ygryOo4VQUZQn+0CNdo=";
    };
  };
in {
  neovim.plugins = {
    lspconfig = {
      package = nvim-lspconfig;
      event = [ "BufReadPre" "BufNewFile" ];
      dependencies = [
        cmp-nvim-lsp
        ltex-extra-nvim
      ];
      config = lib.fileContents ./lspconfig.lua;
      extraBinaries = with pkgs; [
        taplo nil nixpkgs-fmt ltex-ls
      ];
    };

    nvim-cmp = {
      package = nvim-cmp;
      event = "InsertEnter";
      dependencies = [
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp_luasnip
        cmp-hledger
        lspkind-nvim
      ];
      config = lib.fileContents ./cmp.lua;
    };

    luasnip = {
      package = luasnip;
      event = "InsertEnter";
      config = lib.fileContents ./luasnip.lua;
    };

    fidget = {
      package = fidget-nvim;
      event = "LspAttach";
      config = "require('fidget').setup()";
    };
  };
}
