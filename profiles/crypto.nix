{
  mkProfile,
  sage,
  openssl,
}:

mkProfile {
  name = "crypto";
  paths = [
    (sage.override {
      requireSageTests = false;
      extraPythonPackages = ps: with ps; [
        pycryptodome gmpy2
        sympy
        primefac
        fastecdsa
        ecdsa

        grpcio
        grpcio-tools
        rich

        pwntools
        requests
      ];
    })
    openssl
  ];
}
