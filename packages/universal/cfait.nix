{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cfait";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "trougnouf";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8wbQdCWpyzOjawdp/78cKPiBixhLfU5OBUZvKW0i6yY=";
  };

  cargoHash = "sha256-wIMrfW2atR64xUd8li+dplK1qQW2tvA+Fim9kf+xAt4=";

  doCheck = false;

  meta = with lib; {
    description = "Take control of your TODO list";
    homepage = "https://github.com/trougnouf/cfait";
    license = licenses.gpl3;
    maintainers = [];
  };
}

