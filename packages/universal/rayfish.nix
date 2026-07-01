{
lib, fetchFromGitHub, rustPlatform,
alsa-lib, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "rayfish";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "rayfish";
    repo = pname;
    tag = "v0.1.3";
    hash = "sha256-pH+02DsyuWebPHUBzU1QZovB2kFa2da3oCsGIgCLRLM=";
  };

  cargoHash = "sha256-K/FR2LH2yAe9nJJsREYCjGscOK8NXancjBHRjSbeF0Y=";

  # buildInputs = [ alsa-lib ];
  # nativeBuildInputs = [ pkg-config ];

  doCheck = false;

  meta = with lib; {
    description = "P2P mesh VPN powered by iroh — connects peers by cryptographic identity";
    homepage = "https://github.com/rayfish/rayfish";
    license = licenses.mpl20;
  };
}
