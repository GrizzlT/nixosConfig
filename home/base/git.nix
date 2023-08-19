{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "GrizzlT";
    userEmail = "13691001+GrizzlT@users.noreply.github.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      core = {
        autocrlf = "input";
      };
      status = {
        showUntrackedFiles = "all";
      };
    };
    lfs.enable = true;
    delta = {
      enable = true;
      options = {
        side-by-side = false;
        line-numbers = false;
      };
    };
  };
}
