luaByteCompile() {
  echo "Executing luaByteCompile"

  if [[ -f $out ]]; then
    if [[ $out = *.lua ]]; then
      @nvimBin@ -l @luaByteCompileScript@ $out
    fi
  else
    (
      @fdBin@ --unrestricted --extension lua --exclude tests --exclude docgen . $out --exec @nvimBin@ -l @luaByteCompileScript@
    )
  fi
}

preFixupHooks+=(luaByteCompile)
