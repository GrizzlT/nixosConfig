{ lib, runCommand, makeSetupHook, neovim-unwrapped, fd }:
let
  luaByteCompileHook = makeSetupHook {
    name = "lua-byte-compile-hook";
    substitutions = {
      nvimBin = "${neovim-unwrapped}/bin/nvim";
      fdBin = "${fd}/bin/fd";
      luaByteCompileScript = ./lua-byte-compile.lua;
    };
  } ./lua-byte-compile-hook.sh;

  luaFileByteCompile = file: let
    name = if builtins.isPath file
      then builtins.baseNameOf file
      else lib.getName file;
  in
    runCommand name {
      nativeBuildInputs = [luaByteCompileHook];
    } ''
      cp ${file} $out
      chmod u+w $out
      runHook preFixup
    '';

  luaBlock = name: contents: let
    indentedBlock = lib.pipe contents [
      (lib.splitString "\n")
      (builtins.filter (str: str != ""))
      (lib.concatMapStringsSep "\n" (line: "  " + line))
    ];
  in ''
    -- ${name}
    do
    ${indentedBlock}
    end
  '';

  concatNonEmptyStrings = strings:
    lib.pipe strings [
      (builtins.filter (str: str != ""))
      (builtins.concatStringsSep "\n")
    ];
in
{
  inherit luaByteCompileHook luaFileByteCompile luaBlock concatNonEmptyStrings;
}
