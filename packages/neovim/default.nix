{ lib, vimPlugins, vimExtraPlugins, neovim, neovim-unwrapped, wrapNeovimUnstable, neovimUtils, vimUtils,
  writeText, runCommand, makeSetupHook, symlinkJoin, buildEnv, fetchFromGitHub, fetchgit,
  tree-sitter, # Tree sitter
  taplo, # Toml
  nil, nixpkgs-fmt, # Nix
  fd, ripgrep, # Telescope
  unixtools, # xxd
  ltex-ls # ltex-ls
}:
let
  # binaries available to Neovim
  extraPackages = [
    # Toml
    taplo
    # Nix
    nil
    nixpkgs-fmt
    # Telescope
    fd
    ripgrep
    # Hex.nvim
    unixtools.xxd
    # ltex-ls
    ltex-ls
  ];

  plugins = import ./plugins {
    inherit vimPlugins vimExtraPlugins runCommand fetchFromGitHub fetchgit tree-sitter;
    inherit (vimUtils) buildVimPlugin;
    neovim-raw = neovim;
  };

  lua-utils = import ./lua-utils.nix { inherit lib runCommand makeSetupHook neovim-unwrapped fd; };
  plugin-utils = import ./plugin-utils.nix {
    inherit lib buildEnv vimUtils;
    inherit (lua-utils) luaByteCompileHook luaBlock concatNonEmptyStrings;
  };

  lazyNvim = plugin-utils.compilePlugin vimPlugins.lazy-nvim;
  runtimePlugin = plugin-utils.compilePlugin (vimUtils.buildVimPlugin {
    pname = "grizz-runtime";
    version = "0.1.0";
    src = ./runtime;
  });


  lazyPlugins = plugin-utils.buildLazyPlugins plugins;
  lazyConfig = ''
    vim.opt.rtp:prepend("${lazyNvim}")
    require('lazy').setup({
      {
        dir = '${runtimePlugin}',
        lazy = false,
        name = 'grizz-runtime',
        config = function()
          require('grizz-runtime').setup({path = '${runtimePlugin}'})
        end,
        priority = 1500,
      },
      ${lazyPlugins}
    }, {
      install = {
        missing = false,
      },
      checker = {
        enabled = false,
      },
      change_detection ={
        enabled = false,
      },
      performance = {
        cache = {
          enabled = false,
        },
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
      readme = {
        enabled = false,
      },
    })
  '';

  neovimCompiled = symlinkJoin {
    name = "neovim-compiled-${neovim-unwrapped.version}";
    paths = [neovim-unwrapped];
    nativeBuildInputs = [lua-utils.luaByteCompileHook];
    postBuild = "runHook preFixup";
  };

  extraMakeWrapperArgs = lib.optionals (extraPackages != []) [
    "--suffix" "PATH" ":" (lib.makeBinPath extraPackages)
  ];

  extraLuaConfig = lib.pipe ([./init.lua] ++ (lib.lists.optionals (builtins.pathExists ./init.lua.d) (lib.filesystem.listFilesRecursive ./init.lua.d))) [
    (builtins.filter (name: lib.hasSuffix ".lua" name))
    (builtins.map (file: lua-utils.luaBlock (baseNameOf file) file))
    lua-utils.concatNonEmptyStrings
  ];
  initLuaCompiled = lua-utils.luaFileByteCompile (writeText "init.lua" ''
    ${extraLuaConfig}
    ${lazyConfig}
  '');

  initLuaWrapperArgs = [ "--add-flags" "-u ${initLuaCompiled}" ];

  neovimConfig = neovimUtils.makeNeovimConfig {
    withPython3 = false;
    withRuby = false;
  };
in
  wrapNeovimUnstable neovimCompiled (neovimConfig // {
    wrapperArgs = neovimConfig.wrapperArgs ++ extraMakeWrapperArgs ++ initLuaWrapperArgs;
    wrapRc = false;
  })
