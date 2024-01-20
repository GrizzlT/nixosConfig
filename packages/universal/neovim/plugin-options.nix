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
      description = ''Dependencies of this plugin.'';
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
      type = nullOr (oneOf [ str (listOf str) (submodule ./plugin-lazy-key.nix) ]);
      default = null;
    };
    _manual = mkOption {
      type = bool;
      default = true;
      visible = false;
      readOnly = true;
    };
  };
}
