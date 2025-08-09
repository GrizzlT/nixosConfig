{
  mkProfile,
  python312,
  pyright,
}:

mkProfile {
  name = "python";
  paths = [
    (python312.withPackages (ps: with ps; [
      pycryptodome gmpy2
      wandb
      sympy
      primefac
      pypng
      fastecdsa
      ecdsa
      netifaces

      z3-solver

      grpcio
      grpcio-tools
      rich

      angr
      r2pipe
      rzpipe
      pwntools
      requests
      pyserial
      # pyocd

      # tensorflow
      # keras
      opencv4
      # pyzbar
      pillow

      websockets
      flask

      python-lsp-server

      # iphone-backup-decrypt
      javaobj-py3

      numpy
      matplotlib
      scapy
      control
      scipy
    ]))
    pyright
  ];
}

