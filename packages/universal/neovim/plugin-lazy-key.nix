{ lib, config, ... }:
with lib; with types;
let
  cfg = config;
  strList = ls: "{${concatMapStringsSep ", " (x: "'" + x + "'") ls}}";
in
{
  options = {
    lhs = mkOption {
      type = str;
      example = literalExpression "<leader>p";
    };
    rhs = mkOption {
      type = nullOr str;
      default = null;
    };
    mode = mkOption {
      type = nullOr (listOf str);
      default = null;
    };
    ft = mkOption {
      type = nullOr (listOf str);
      default = null;
    };
    opts = mkOption {
      type = nullOr (attrsOf anything);
      default = null;
    };
    lazySpec = mkOption {
      type = str;
      visible = false;
      readOnly = true;
    };
  };

  config = let
    rhs = optionalString (cfg.rhs != null)
      (if ((builtins.match "^[[:space:]]*function.*" cfg.rhs) == []) then "${cfg.rhs}, " else "'${cfg.rhs}', ");
    mode = optionalString (cfg.mode != null) "mode = ${strList cfg.mode}, ";
    ft = optionalString (cfg.ft != null) "ft = ${strList cfg.ft}, ";
    opts = optionalString (cfg.opts != null) "{${concatStringsSep ", " (mapAttrsToList (n: v: n + " = \"${toString v}\"") cfg.opts)}}";
  in {
    lazySpec = ''
      { '${cfg.lhs}', ${rhs}${mode}${ft}${opts}}
    '';
  };
}
