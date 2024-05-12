{
  mkProfile,
  sage,
  primefac,
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
        (primefac ps)
        fastecdsa
        ecdsa

        pwntools
        requests
      ];
    })
    openssl
  ];
}
