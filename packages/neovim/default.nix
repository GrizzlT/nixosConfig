{ lib, vimPlugins, neovim-unwrapped, wrapNeovimUnstable, neovimUtils, vimUtils,
  writeText, runCommand, makeSetupHook, symlinkJoin, buildEnv,
  taplo, # Toml
  nil, nixpkgs-fmt, # Nix
  fd, ripgrep, # Telescope
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
  ];

  plugins = let
    nvim-treesitter' = vimPlugins.nvim-treesitter.withPlugins (parsers:
      with parsers; [
        query toml lua rust gitcommit gitignore json markdown nix bash
      ]);
  in with vimPlugins;
  [
    {
      plugin = dracula-nvim;
      lazy = false;
      priority = 1000;
    }
    {
      plugin = nvim-treesitter';
      event = "BufRead";
    }
    lush-nvim
  ];

  lua-utils = import ./lua-utils.nix { inherit lib runCommand makeSetupHook neovim-unwrapped fd; };
  plugin-utils = import ./plugin-utils.nix {
    inherit lib buildEnv vimUtils;
    inherit (lua-utils) luaByteCompileHook luaBlock concatNonEmptyStrings;
  };

  lazyNvim = plugin-utils.compilePlugin vimPlugins.lazy-nvim;

  lazyPlugins = plugin-utils.buildLazyPlugins plugins;
  lazyConfig = ''
    vim.opt.rtp:prepend("${lazyNvim}")
    require('lazy').setup({
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
    ${lazyConfig}
    ${extraLuaConfig}
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
