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
    neovim._lazyConfig = mkOption {
      type = anything;
      readOnly = true;
      visible = false;
    };
    neovim.extraBinaries = mkOption {
      type = listOf package;
      default = [];
    };
    neovim._extraBinaries = mkOption {
      type = listOf package;
      readOnly = true;
      visible = false;
    };
    neovim.lazyOpts = mkOption {
      type = str;
      default = ''{
        install = {
          missing = false,
        },
        checker = {
          enabled = false,
        },
        performance = {
          rtp = {
            disabled_plugins = {
              'gzip',
              'matchit',
              'netrwPlugin',
              'tarPlugin',
              'spellfile',
              'tohtml',
              'tutor',
              'zipPlugin',
            },
          },
        },
      }'';
    };
  };

  config = let
    normalizeName = plugin: builtins.replaceStrings ["."] ["-"] (getName plugin);

    # Check for unique values in list -> done by map head . group . sort
    isUniqueAttrs = attrToStr: set: with builtins; let xs = attrValues set; in
      length (map head (attrValues (groupBy attrToStr (sort (x: y: attrToStr x < (attrToStr y)) xs)))) == (length xs);
    # is there an attrset with a specific `attr` `x` in the given list `xs`?
    containsXAttr = attr: x: xs: any (p: p.${attr} == x) xs;

    # Expand the plugin list with implicit dependency plugins
    allPlugins = foldl' (acc: p: acc // (
      foldl' (xs: x: xs // (
        if !(containsXAttr "package" x (attrValues acc)) then let name = normalizeName x; in
          { ${name} = { package = x; inherit name; }; }
        else {})) {} p.dependencies           # for every dependency
      )) cfg (attrValues cfg);                # for every plugin

    # Get the plugin definition based on plugin package
    pkgToPlugin = pkg: findFirst (v: v.package == pkg) {} (attrValues allPlugins);
    # Implicit dependency expanded locally, explicit dependency is referenced by name
    dependencyConfig = w: dep: let p = pkgToPlugin dep; in
      if (p ? "_manual") then
        "\n'${p.name}'," else
        ''''\n{
          dir = '${w p.package}',
          name = '${p.name}',
        },'';

    # x => 'x' and [ x v ] => { 'x', 'v' }
    strOrStringList = x: if (builtins.isList x) then "{${concatMapStringsSep ", " (e: "'${e}'") x}}" else "'${x}'";
    # x => 'x' and [ x v ] => { { 'x', }, { 'v', } }
    lazyKeys = x: if (builtins.isList x) then "{${concatMapStringsSep ", " (e: if e ? "lazySpec" then e.lazySpec else "{ '${e}', }") x}}" else "'${x}'";

    pluginConfig = w: plugin: ''{
      dir = '${w plugin.package}',
      name = '${plugin.name}',
      lazy = ${boolToString plugin.lazy},''
        + (if (plugin.dependencies != []) then "\ndependencies = { ${toString (map (dependencyConfig w) plugin.dependencies)} }," else "")
        + (if (plugin.priority != null) then "\npriority = ${toString plugin.priority}," else "")
        + (if (plugin.event != null) then "\nevent = ${strOrStringList plugin.event}," else "")
        + (if (plugin.cmd != null) then "\ncmd = ${strOrStringList plugin.cmd}," else "")
        + (if (plugin.ft != null) then "\nft = ${strOrStringList plugin.ft}," else "")
        + (if (plugin.keys != null) then "\nkeys = ${lazyKeys plugin.keys}," else "")
        + (if (plugin.config != null) then "\nconfig = function() \n${plugin.config} \nend," else "")
        + "\n}";
  in {
    assertions = [{
      assertion = isUniqueAttrs (x: getName x.package) cfg;
      message = "All plugin packages must be listed at most once.";
    } {
      assertion = isUniqueAttrs (x: x.name) allPlugins;
      message = "All plugin names must be unique.";
    }];

    neovim = {
      _lazyConfig = w: map (pluginConfig w) (attrValues cfg);
      _extraBinaries = lib.unique (flatten (mapAttrsToList (_: p: p.extraBinaries) cfg) ++ config.neovim.extraBinaries);
    };
  };
}
