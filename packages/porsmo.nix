{
lib, fetchFromGitHub, rustPlatform,
alsa-lib, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "porsmo";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "ColorCookie-dev";
    repo = pname;
    rev = "4a629d69bc9993433a595f9396f6e16fa7c010d6";
    sha256 = "T1cAQi/mEokbg/tcDphP58NWeZLI7YGaUvRJeCtojtk=";
  };

  cargoSha256 = "58I1go9YErqaL4Kw/vRMvVH8+0keFhXjXyvorDqyBcc=";

  buildInputs = [ alsa-lib ];
  nativeBuildInputs = [ pkg-config ];

  doCheck = false;

  meta = with lib; {
    description = "Pomodoro cli app in rust with timer and countdown";
    homepage = "https://github.com/ColorCookie-dev/porsmo";
    license = licenses.mit;
  };
}
