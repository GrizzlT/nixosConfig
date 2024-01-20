{ lib, config, ... }:
with lib; with types;
let
  cfg = config.neovim.plugins;
in
{
  options = {
    neovim.plugins = mkOption {
      type = lazyAttrsOf (submodule ./plugin-options.nix) // {
        merge = _: _: abort "Neovim plugins must not be defined more than once.";
      };
      default = {};
    };
    neovim.pluginConfigs = mkOption {
      type = anything;
      readOnly = true;
      visible = false;
    };
  };

  config = let
    normalizeName = plugin: builtins.replaceStrings ["."] ["-"] (getName plugin);
    containsPkg = pkg: xs: any (p: p.package == pkg) xs;

    isDependency = plugin: plugin._manual or false;

    allPlugins = foldl' (acc: p: acc ++ (
      foldl' (xs: x: xs ++ (
        if !(containsPkg x acc) then              # add dependency if not already in acc
          [ { package = x; name = normalizeName x; } ]
        else [])) [] p.dependencies               # for every dependency
      )) (attrValues cfg) (attrValues cfg);       # for every plugin
    dependencyName = dep: (findFirst (v: v.package == dep) allPlugins).name or (normalizeName dep);

    pluginConfig = plugin: ''

    '';
  in {
    neovim.pluginConfigs = { plugins = allPlugins; };
  };
}
