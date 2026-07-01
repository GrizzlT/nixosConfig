{
lib, fetchFromGitHub, rustPlatform,
alsa-lib, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "rayfish";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "GrizzlT";
    repo = pname;
    # tag = "v0.1.3";
    rev = "ee706c604a6c6e4051da341139ed4374733b56e7";
    hash = "sha256-TPVqorX8DwwIV4ci/2OgFbnqiUsQKcYdFbpldldQ2/E=";
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
