{
  mkProfile,
  python311,
  pyright,
}:

mkProfile {
  name = "python";
  paths = [
    (python311.withPackages (ps: with ps; [
      pycryptodome gmpy2
      sympy
      primefac
      pypng
      fastecdsa
      ecdsa
      netifaces

      grpcio
      grpcio-tools
      rich

      r2pipe
      rzpipe
      pwntools
      requests
      pyserial
      # pyocd

      # tensorflow
      # keras
      # opencv4
      # pyzbar
      #
      # pyzmq
      flask

      python-lsp-server

      numpy
      matplotlib
    ]))
    pyright
  ];
}

