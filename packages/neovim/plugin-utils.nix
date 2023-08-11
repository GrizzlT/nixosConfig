{
  lib, buildEnv, vimUtils, luaByteCompileHook, luaBlock, concatNonEmptyStrings,
}:
let
  defaultLazyPlugin = {
    plugin = null;
    lazy = true;
  };

  normalizeLazyPlugins = lazyPlugins:
    map (x: defaultLazyPlugin // (if (x ? plugin) then x else { plugin = x; })) lazyPlugins;

  extendWithDependencies = lazyPlugins: let
    containsPlugin = acc: plugin: lib.any (lazyPlugin: (if (lazyPlugin ? plugin) then lazyPlugin.plugin == plugin else lazyPlugin == plugin)) acc;
    pluginWithDeps = acc: plugin:
      (if (containsPlugin acc plugin) then [] else [plugin])
      ++ builtins.concatMap (pluginWithDeps acc) plugin.dependencies or [];
    allDeps = lib.unique (lib.concatMap (lazyPlugin: lazyPlugin.plugin.dependencies or [] ++ lazyPlugin.dependencies or []) lazyPlugins);
  in
    normalizeLazyPlugins (lib.foldl (acc: plugin: acc ++ pluginWithDeps acc plugin) lazyPlugins allDeps);

  pluginNormalizeName = name: builtins.replaceStrings ["."] ["-"] name;

  compilePlugin = plugin: plugin.overrideAttrs (prev: {
    nativeBuildInputs = prev.nativeBuildInputs or [] ++ [luaByteCompileHook];
  });

  compileLazyPlugins = lazyPlugins: lib.forEach lazyPlugins (lazyPlugin:
    lazyPlugin // { plugin = compilePlugin lazyPlugin.plugin; });

  buildLazyPlugins = lazyPlugins: let
    buildLazyConfig = lazyPlugin: let
      pluginName = lazyPlugin: lib.getName lazyPlugin.plugin;
      pluginConfig = name: let
        configPath = ./plugins/${pluginNormalizeName name}.lua;
      in
        lib.optionalString (builtins.pathExists configPath) (luaBlock name configPath);

      pluginDeps = map (dep: pluginNormalizeName (lib.getName dep)) (lib.unique lazyPlugin.plugin.dependencies or [] ++ lazyPlugin.dependencies or []);
      pluginDepsString = lib.concatMapStringsSep ", " (depName: "'" + depName + "'") pluginDeps;

      priorityString = lib.optionalString (lazyPlugin ? priority) ''priority = ${toString lazyPlugin.priority},'';
      listToString = ls: lib.concatMapStringsSep ", " (elem: "'" + elem + "'") ls;
      stringOrListToString = value: if (builtins.isList value) then "{${listToString value}}" else "'" + value + "'";
      eventString = lib.optionalString (lazyPlugin ? event) ''event = ${stringOrListToString lazyPlugin.event},'';
      cmdString = lib.optionalString (lazyPlugin ? cmd) ''cmd = ${stringOrListToString lazyPlugin.cmd},'';
      ftString = lib.optionalString (lazyPlugin ? ft) ''ft = ${stringOrListToString lazyPlugin.ft},'';

      lazyKey = key: let
        lhs = "'${key.lhs}', ";
        rhs = lib.optionalString (key ? rhs) "'${key.rhs}', ";
        mode = lib.optionalString (key ? mode) "mode = ${stringOrListToString key.mode}, ";
        opts = lib.optionalString (key ? opts) key.opts;
      in ''{ ${lhs} ${rhs} ${mode} ${opts} }'';
      keySpec = keys: if (builtins.isString keys) then ("'" + keys + "'") else (if (builtins.isList keys) then (lib.concatMapStringsSep ", " listKeySpec keys) else lazyKey keys);
      listKeySpec = key: if (builtins.isString key) then "{ '" + key + "', mode = 'n'}" else lazyKey key;
      keysString = lib.optionalString (lazyPlugin ? keys) ''keys = {
        ${keySpec lazyPlugin.keys}
      }'';
    in ''
      {
        dir = "${lazyPlugin.plugin}",
        name = "${pluginNormalizeName (pluginName lazyPlugin)}",
        lazy = ${if lazyPlugin.lazy then "true" else "false" },
        dependencies = {
          ${pluginDepsString}
        },
        config = function()
          ${pluginConfig (pluginName lazyPlugin)}
        end,
        ${priorityString}
        ${eventString}
        ${cmdString}
        ${ftString}
        ${keysString}
      }
    '';
  in
    lib.pipe (compileLazyPlugins (extendWithDependencies (normalizeLazyPlugins lazyPlugins))) [
      (map buildLazyConfig)
      (lib.concatStringsSep ",")
    ];
  in {
    inherit compilePlugin buildLazyPlugins;
  }
