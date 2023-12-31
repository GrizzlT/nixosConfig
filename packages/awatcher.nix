{ rustPlatform, lib, fetchFromGitHub, pkg-config, libressl_3_7 }:

rustPlatform.buildRustPackage rec {
  pname = "awatcher";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "2e3s";
    repo = pname;
    rev = "v0.2.1";
    sha256 = "MP66FAvNstiHDIGS/SolctY1pWlysY3p0PYWPZSGkQI=";
  };

  cargoLock = {
    lockFile = ./awatcher-cargo.lock;
    outputHashes = {
      "aw-client-rust-0.1.0" = "fCjVfmjrwMSa8MFgnC8n5jPzdaqSmNNdMRaYHNbs8Bo=";
    };
  };

  buildInputs = [ libressl_3_7 ];
  nativeBuildInputs = [ pkg-config ];
}
