{
  mkProfile,
  python311,
  primefac,
  padding-oracle,
}:

mkProfile {
  name = "python";
  paths = [
    (python311.withPackages (ps: with ps; [
      pycryptodome gmpy2 pkgs.sage.with-env
      sympy
      (primefac ps)
      pypng
      fastecdsa
      ecdsa
      netifaces
      (padding-oracle ps)

      r2pipe
      rzpipe
      pwntools
      requests
      ply
      pyserial
      pyocd

      tensorflow
      keras
      opencv4
      pyzbar

      python-lsp-server

      matplotlib
      portalocker
    ]))
  ];
}

