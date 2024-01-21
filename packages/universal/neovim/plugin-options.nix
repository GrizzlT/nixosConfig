{ lib, config, ... }:
with lib; with types;
let normalizeName = plugin: builtins.replaceStrings ["."] ["-"] (getName plugin); in
{
  options = {
    package = mkOption {
      type = package;
      description = mdDoc "The package of the plugin.";
    };
    lazy = mkOption {
      type = bool;
      default = true;
      example = literalExpression "false";
      description = "Whether to lazy load this plugin.";
    };
    name = mkOption {
      type = str;
      default = normalizeName config.package;
      example = "plenary-nvim";
      description = "Custom name of the plugin.";
    };
    dependencies = mkOption {
      type = listOf package;
      default = [];
      example = literalExpression "[ pkgs.vimPlugins.plenary-nvim ]";
      description = ''Dependency plugins of this plugin.'';
    };
    extraBinaries = mkOption {
      type = listOf package;
      default = [];
      example = literalExpression "[ pkgs.nil ]";
      description = "Extra binaries for neovim's path.";
    };
    priority = mkOption {
      type = nullOr int;
      default = null;
      example = literalExpression "100";
      description = ''The priority of this plugin, higher values load first'';
    };
    event = mkOption {
      type = nullOr (either str (listOf str));
      default = null;
    };
    cmd = mkOption {
      type = nullOr (either str (listOf str));
      default = null;
    };
    ft = mkOption {
      type = nullOr (either str (listOf str));
      default = null;
    };
    keys = mkOption {
      type = nullOr (either str (listOf (oneOf [ str (submodule ./plugin-lazy-key.nix) ])));
      default = null;
    };
    config = mkOption {
      type = nullOr lines;
      default = null;
      example = literalExpression "function() require('lualine').setup() end";
      description = "Config for this plugin";
    };
    _manual = mkOption {
      type = bool;
      default = true;
      visible = false;
      readOnly = true;
    };
  };
}
