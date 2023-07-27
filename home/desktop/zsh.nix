{ pkgs, ... }:
{
  # for zsh graphical plugins
  programs.zsh.plugins = [
    {
      name = "auto-notify";
      src = pkgs.fetchFromGitHub {
        owner = "MichaelAquilina";
        repo = "zsh-auto-notify";
        rev = "22b2c61ed18514b4002acc626d7f19aa7cb2e34c";
        sha256 = "x+6UPghRB64nxuhJcBaPQ1kPhsDx3HJv0TLJT5rjZpA=";
      };
    }
    {
      name = "clipboard";
      src = pkgs.fetchFromGitHub {
        owner = "zpm-zsh/clipboard";
        repo = "clipboard";
        rev = "7fbd15150fe0fc84a34b6aa9e31c5589de3c9ffc";
      };
    }
  ];
}
