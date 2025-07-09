{
lib, fetchFromGitHub, rustPlatform,
alsa-lib, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "porsmo";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ColorCookie-dev";
    repo = pname;
    rev = "724d3e283222fd658ae3aba18f334a565ada6148";
    sha256 = "WoLh1i5S4X//F2RRHTyFfM2e53SP+wSQd57rD7CGQik=";
  };

  cargoHash = "sha256-zkeQY0YNcKfyaWHmv1N61dBggsvFzz1fgkjXkyYK3Lg=";

  buildInputs = [ alsa-lib ];
  nativeBuildInputs = [ pkg-config ];

  doCheck = false;

  meta = with lib; {
    description = "Pomodoro cli app in rust with timer and countdown";
    homepage = "https://github.com/ColorCookie-dev/porsmo";
    license = licenses.mit;
  };
}
