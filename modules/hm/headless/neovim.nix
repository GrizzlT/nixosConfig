{ selfPkgs, ... }:
{
  home.packages = [
    selfPkgs.neovim
  ];

  # Relative path to nvim for ease of use,
  # together with the config above will always work
  home.sessionVariables.EDITOR = "nvim";
}
