{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "13691001+GrizzlT@users.noreply.github.com";
        name = "GrizzlT";
      };
      alias = {
        s = "status --short";
        co = "checkout";
        br = "branch";
        c = "commit --verbose";
        ca = "commit --amend --verbose";
        can = "commit --amend --no-edit --verbose";
      };
      init = {
        defaultBranch = "main";
      };
      core = {
        autocrlf = "input";
      };
      status = {
        branch = true;
        showStash = true;
        showUntrackedFiles = "all";
      };
    };
    includes = [
      {
        condition = "hasconfig:remote.*.url:git@github.com:*/**";
        contents = {
          user = {
            name = "GrizzlT";
            email = "13691001+GrizzlT@users.noreply.github.com";
            signingKey = "25DDB581DA2025B7!";
          };
          commit = {
            gpgSign = true;
          };
        };
      }
    ];
  };
}
