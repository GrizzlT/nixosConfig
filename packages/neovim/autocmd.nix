{ pkgs, ... }:
{
  autoCmd = [
    {
      pattern = "*";
      callback = { __raw = ''
        function()
          vim.highlight.on_yank({
              higroup = 'IncSearch',
              timeout = 40,
          })
        end
      ''; };
    }
    {
      event = "BufWritePre";
      pattern = "*";
      command = ''[[%s/\s\+$//e]]'';
    }
    {
      event = [ "BufEnter" "BufWinEnter" ];
      pattern = [ "/tmp/*" "COMMIT_EDITMSG" "MERGE_MSG" "*.tmp" "*.bak" "/private/*" ];
      callback = { __raw = ''
        function()
            vim.opt_local.undofile = false
            vim.opt_local.writebackup = false
        end,
      ''; };
    }
  ];
}
