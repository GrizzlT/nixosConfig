{
  mkProfile,
  python311,
}:

mkProfile {
  name = "python";
  paths = [
    (python311.withPackages (ps: with ps; [
      pycryptodome gmpy2 pkgs.sage.with-env
      sympy
      primefac
      pypng
      fastecdsa
      ecdsa
      netifaces

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

