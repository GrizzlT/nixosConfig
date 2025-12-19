{ ... }:
{
  programs.delta = {
    enable = true;
    options = {
      side-by-side = false;
      line-numbers = false;
    };
    enableGitIntegration = true;
  };
  programs.git = {
    lfs.enable = true;
  };

  programs.lazygit = {
    enable = true;
    settings = {
      git.paging.pager = "delta --dark --paging=never";
    };
  };
}
