{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule {
  pname = "hledger-lsp";
  version = "0.2.27";

  src = fetchFromGitHub {
    owner = "juev";
    repo = "hledger-lsp";
    rev = "v0.2.27";
    sha256 = "sha256-N5gHySUMSiPJaOHrHHRnSZRzh81Hy8RCetZkkJJqDzw=";
  };

  vendorHash = "sha256-Oo/8LCX6svcH/0vCowzOiAhlif9LJfNrU3OgNiZDupo=";

  # If upstream uses ./cmd/hledger-lsp (very likely)
  subPackages = [ "cmd/hledger-lsp" ];

  # # No CGO deps expected, but keep deterministic
  # CGO_ENABLED = 0;

  meta = with lib; {
    description = "Language server for hledger";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
