{ ... }:
{
  programs.git = {
    lfs.enable = true;
    delta = {
      enable = true;
      options = {
        side-by-side = false;
        line-numbers = false;
      };
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      git.paging.pager = "delta --dark --paging=never";
    };
  };
}
