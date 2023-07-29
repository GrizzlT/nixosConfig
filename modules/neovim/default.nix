# Code inspired by github.com/stasjok/dotfiles

{ pkgs, lib, config, ... }:
let
  cfg = config.programs.neovim;

  # A hook to byte-compile all lua files in $out
  luaByteCompileHook = pkgs.makeSetupHook {
    name = "lua-byte-compile-hook";
    substitutions = {
      nvimBin = "${pkgs.neovim-unwrapped}/bin/nvim";
      luaByteCompileScript = ./lua-byte-compile.lua;
    };
  } ./lua-byte-compile-hook.sh;

  # Byte-compile a single lua file
  byteCompileLuaFile = file: let
    name = if builtins.isPath file
      then builtins.baseNameOf file
      else lib.getName file;
  in
    pkgs.runCommand name {
      nativeBuildInputs = [luaByteCompileHook];
    } ''
      cp ${file} $out
      chmod u+w $out
      runHook preFixup
    '';

    # Read a lua chunk from file, wrap it in do...end block, and prefix it with `name` comment
    luaBlock = name: file: let
      indentedBlock = lib.pipe (lib.fileContents file) [
        (lib.splitString "\n")
        (lib.concatMapStringsSep "\n" (line:
          if line == ""
          then line
          else "  " + line))
      ];
    in ''
      -- ${name}
      do
      ${lib.removeSuffix "\n" indentedBlock}
      end
    '';

    concatNonEmptyStringsSep = strings:
      lib.pipe strings [
        (builtins.filter (str: str != ""))
        (builtins.concatStringsSep "\n")
      ];
in
{
  programs.neovim = {
    enable = true;

    withNodeJs = false;
    withPython3 = false;
    withRuby = false;

    defaultEditor = true;

    package = let
      neovim = pkgs.neovim-unwrapped;
    in
      pkgs.symlinkJoin {
        name = "neovim-compiled-${neovim.version}";
        paths = [neovim];
        nativeBuildInputs = [luaByteCompileHook];
        # Activate vimGenDocHook manually
        postBuild = "runHook preFixup";
        # Copy required attributes from original neovim package
        inherit (neovim) lua;
      };

    extraPackages = with pkgs; [
      # Nix
      nil
      nixpkgs-fmt
    ];

    extraLuaConfig = lib.pipe ([./init.lua] ++ lib.filesystem.listFilesRecursive ./init.lua.d) [
      (builtins.filter (name: lib.hasSuffix ".lua" name))
      (builtins.map (file: luaBlock (baseNameOf file) file))
      concatNonEmptyStringsSep
    ];

    # Neovim plugins
    plugins = let
      # All plugins with its dependencies are placed in a start directory
      # Python deps are not supported
      plugins = with pkgs.vimPlugins; let
        nvim-treesitter' = nvim-treesitter.withPlugins (parsers:
          with parsers; [
            query toml lua rust gitcommit gitignore json markdown nix
          ]
        );
      in [
        # Colorscheme
        onedark-nvim
        # Libraries
        plenary-nvim
        nvim-treesitter'
        # Auto-completion
        nvim-cmp
        cmp-buffer
        cmp-path
        cmp-nvim-lsp
        cmp_luasnip
        # Snippets
        luasnip
        # Languages
        vim-nix
      ];

      # Extend plugin list with dependencies
      allPlugins = let
        pluginWithDeps = plugin: [plugin] ++ builtins.concatMap pluginWithDeps plugin.dependencies or [];
      in
        lib.unique (builtins.concatMap pluginWithDeps plugins);

      # Byte-compile all plugins, remove help tags
      allPlugins' = lib.forEach allPlugins (plugin:
        plugin.overrideAttrs (prev: {
          nativeBuildInputs = lib.remove pkgs.vimUtils.vimGenDocHook prev.nativeBuildInputs or []
          ++ [luaByteCompileHook];
          configurePhase = concatNonEmptyStringsSep
            (builtins.filter (s: s != ":") [
              prev.configurePhase or ":"
              "rm -f doc/tags"
            ]);
          }));

      # Merge all plugins to one pack
      mergedPlugins = pkgs.vimUtils.toVimPlugin (pkgs.buildEnv {
        name = "plugin-pack";
        paths = allPlugins';
        pathsToLink = [
          # :h rtp
          "/autoload"
          "/colors"
          "/compiler"
          "/doc"
          "/ftplugin"
          "/indent"
          "keymap"
          "/lang"
          "/lua"
          "/pack"
          "/parser"
          "/plugin"
          "/queries"
          "/rplugin"
          "/spell"
          "/syntax"
          "/tutor"
          "/after"
          # ftdetect
          "/ftdetect"
          # plenary.nvim
          "/data"
          # telescope-fzf-native.nvim
          "/build"
        ];
        postBuild = ''
          find $out -type d -empty -delete
          runHook preFixup
        '';
      });

      # Normalized plugin name
      pluginNormalizedName = name: builtins.replaceStrings ["."] ["-"] name;

      # Get plugin config
      pluginConfig = name: let
        configPath = ./plugins/${pluginNormalizedName name}/config.lua;
      in
        lib.optionalString (builtins.pathExists configPath) (luaBlock name configPath);

      # Make attributes for runtime attribute of a plugin
      mkRuntimeAttrs = dir:
        lib.pipe dir [
          lib.filesystem.listFilesRecursive
          (builtins.map (path: lib.removePrefix (builtins.toString dir + "/") (builtins.toString path)))
          (lib.flip lib.genAttrs (name: {
            source = if lib.hasSuffix ".lua" name
              then byteCompileLuaFile /${dir}/${name}
              else /${dir}/${name};
          }))
        ];

      # Get plugin runtime
      pluginRuntime = name: let
        runtimeDir = ./plugins/${pluginNormalizedName name}/runtime;
      in
        lib.optionalAttrs (builtins.pathExists runtimeDir) (mkRuntimeAttrs runtimeDir);

      # List of plugin names
      pluginNames = builtins.map lib.getName plugins;

      config = concatNonEmptyStringsSep (builtins.map pluginConfig pluginNames
        ++ [(luaBlock "init_after.lua" ./init_after.lua)]);

      # Merge all runtime files
      runtime = let
        pluginRuntimes = builtins.map pluginRuntime pluginNames;

        # List of plugin sources for lua-language-server
        luaLsLibrary = {
          "lua_ls_library.json" = {
            text = lib.pipe allPlugins [
              (builtins.filter (plugin: builtins.pathExists "${plugin}/lua"))
              # Append types and neovim runtime
              (lib.concat [pkgs.vimPlugins.neodev-nvim pkgs.neovim-unwrapped])
              (builtins.map (plugin: lib.nameValuePair (pluginNormalizedName (lib.getName plugin)) plugin))
              builtins.listToAttrs
              builtins.toJSON
            ];
          };
        };
      in
        builtins.foldl' (r1: r2: r1 // r2) (mkRuntimeAttrs ./runtime // luaLsLibrary) pluginRuntimes;
    in [
      {
        plugin = mergedPlugins;
        inherit config runtime;
        type = "lua";
      }
    ];

    # Byte-compile init.lua
    xdg.configFile."nvim/init.lua" = let
      initLua = pkgs.writeText "init.lua" ''
        ${cfg.extraLuaConfig}
        ${cfg.generatedConfigs.lua}'';
      initLuaCompiled = byteCompileLuaFile initLua;
    in
      lib.mkForce {
        source = initLuaCompiled;
      };
  };
}
