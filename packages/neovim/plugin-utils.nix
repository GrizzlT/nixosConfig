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
    allDeps = lib.concatMap (lazyPlugin: lazyPlugin.plugin.dependencies or []) lazyPlugins;
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

      pluginDeps = map (dep: pluginNormalizeName (lib.getName dep)) lazyPlugin.plugin.dependencies or [];
      pluginDepsString = lib.concatMapStringsSep ", " (depName: "'" + depName + "'") pluginDeps;
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
    '' + lib.optionalString (lazyPlugin ? priority) ''priority = ${toString lazyPlugin.priority},'' + ''
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
