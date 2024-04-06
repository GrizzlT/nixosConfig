{
  mkProfile,
  python311,
  primefac
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
    ]))
  ];
}

