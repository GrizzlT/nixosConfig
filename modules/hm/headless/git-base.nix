{ ... }:
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
            signingKey = "7F9B170ADDE10B46!";
          };
          commit = {
            gpgSign = true;
          };
        };
      }
    ];
    aliases = {
      s = "status --short";
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
        branch = true;
        showStash = true;
        showUntrackedFiles = "all";
      };
    };
  };
}
