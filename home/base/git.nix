{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "GrizzlT";
    userEmail = "13691001+GrizzlT@users.noreply.github.com";
    extraConfig = {
      core = {
        defaultBranch = "main";
        autocrlf = "input";
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
