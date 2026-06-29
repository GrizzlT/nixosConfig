{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cfait";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "trougnouf";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FO69bmUhP6S3MRbVZllxmpn1GuM8fplciAka46Dz2Yg";
  };

  cargoHash = "sha256-FO69bmUhP6S3MRbVZllxmpn1GuM8fplciAka46Dz2Yg=";

  meta = with lib; {
    description = "Take control of your TODO list";
    homepage = "https://github.com/trougnouf/cfait";
    license = licenses.gpl3;
    maintainers = [];
  };
}

