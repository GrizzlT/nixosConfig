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
            signingKey = "622A1FC9BFA26DDC!";
          };
          commit = {
            gpgSign = true;
          };
        };
      }
    ];
    aliases = {
      s = "status";
      co = "checkout";
      br = "branch";
      c = "commit --verbose";
      ca = "commit --amend --verbose";
      can = "commit --amend --no-edit --verbose";
    };
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
