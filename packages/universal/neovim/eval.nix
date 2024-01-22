{ pkgs, lib, vimExtraPlugins, ... }:
let
  pluginsEval = (lib.evalModules {
    modules = [
      (pkgs.path + "/nixos/modules/misc/assertions.nix")
      ./nvim-plugin-module.nix
      ./configuration.nix
    ];
    specialArgs = {
      inherit pkgs;
      vimPlugins = pkgs.vimPlugins // vimExtraPlugins;
    };
  }).config;

  lua-utils = pkgs.callPackage ./lua-utils.nix {};
  compiledDrv = drv: drv.overrideAttrs (prev: {
    nativeBuildInputs = prev.nativeBuildInputs or [] ++ [lua-utils.luaByteCompileHook];
  });
  # Cannot go into module because path would get lost -> required for snippet loading
  localRuntimePlugin = compiledDrv (pkgs.vimUtils.buildVimPlugin {
    pname = "local-runtime-nixified";
    version = "0.1.0";
    src = ./runtime;
  });
  lazyConfig = ''
    vim.opt.rtp:prepend("${compiledDrv vimExtraPlugins.lazy-nvim}")
    require('lazy').setup({
      {
        dir = '${localRuntimePlugin}',
        lazy = false,
        name = 'local-runtime',
        config = function()
          require('local-runtime').setup({path = '${localRuntimePlugin}'})
        end,
        priority = 1500,
      },
      ${lib.concatStringsSep ",\n" (pluginsEval.neovim._lazyConfig compiledDrv)}
    }, ${pluginsEval.neovim.lazyOpts})
  '';

  neovimCompiled = with pkgs; symlinkJoin {
    name = "neovim-compiled-${neovim-unwrapped.version}";
    paths = [neovim-unwrapped];
    nativeBuildInputs = [lua-utils.luaByteCompileHook];
    postBuild = "runHook preFixup";
  };

  extraMakeWrapperArgs = lib.optionals (pluginsEval.neovim._extraBinaries != []) [
    "--suffix" "PATH" ":" (lib.makeBinPath pluginsEval.neovim._extraBinaries)
  ];

  extraLuaConfig = with builtins; lib.pipe ([./init.lua.d/init.lua]
    ++ (filter (n: lib.hasSuffix ".lua" n && !(lib.hasSuffix "/init.lua" n)) (lib.lists.optionals (builtins.pathExists ./init.lua.d) (lib.filesystem.listFilesRecursive ./init.lua.d))))
  [
    (builtins.map (file: lua-utils.luaBlock (baseNameOf file) (lib.fileContents file)))
    lua-utils.concatNonEmptyStrings
  ];
  initLuaCompiled = lua-utils.luaFileByteCompile (pkgs.writeText "init.lua" ''
    ${extraLuaConfig}
    ${lazyConfig}
  '');

  initLuaWrapperArgs = [ "--add-flags" "-u ${initLuaCompiled}" ];

  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    withPython3 = false;
    withRuby = false;
  };

  failedAssertions = map (x: x.message) (builtins.filter (x: !x.assertion) pluginsEval.assertions);
in
  if failedAssertions != []
    then throw "\nFailed assertions:\n${lib.concatStringsSep "\n" (map (x: "- ${x}") failedAssertions)}"
    else lib.showWarnings pluginsEval.warnings
pkgs.wrapNeovimUnstable neovimCompiled (neovimConfig // {
  wrapperArgs = neovimConfig.wrapperArgs ++ extraMakeWrapperArgs ++ initLuaWrapperArgs;
  wrapRc = false;
})
