{ pkgs, ... }:
{
  config = {
    options = {
      termguicolors = true;

      ignorecase = true;
      smartcase = true;

      number = true;
      relativenumber = true;
      signcolumn = "yes";
      colorcolumn = "80,100";

      scrolloff = 5;
      wrap = false;
      breakindent = true;
      shiftwidth = 4;
      softtabstop = 4;
      tabstop = 4;
      expandtab = true;

      splitright = true;
      splitbelow = true;
      mouse = "";
      showmode = false;
      completeopt = "menu,menuone,noinsert";
      virtualedit = "block";

      backup = false;
      writebackup = true;

      undofile = true;

      hlsearch = false;
      incsearch = true;
      timeoutlen = 500;
    };

    globals = {
      mapleader = ",";
      maplocalleader = ";";

      netrw_browse_split = 0;
      netrw_banner = 0;
      netrw_winsize = 25;
    };
  };
}
