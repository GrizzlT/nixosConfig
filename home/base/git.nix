{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "GrizzlT";
    userEmail = "13691001+GrizzlT@users.noreply.github.com";
    includes = [
      {
        condition = "hasconfig:remote.*.url:git@github.com:*/**";
        contents = {
          user = {
            name = "GrizzlT";
            email = "13691001+GrizzlT@users.noreply.github.com";
            signingKey = "622A1FC9BFA26DDC";
          };
          commit = {
            gpgSign = true;
          };
        };
      }
    ];
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
