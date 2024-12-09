{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "paper-age";
  version = "v1.2.0";

  src = fetchFromGitHub {
    owner = "matiaskorhonen";
    repo = pname;
    rev = version;
    sha256= "7dd1R41CDgkpFI8fUWCJfgz3lr22IjWQYW6vRYEFidc=";
  };

  cargoHash = "sha256-sHu2fk6BV2aC3GIH3QnwMeV/h/o8cEOnhD4Iz4X6Lbc=";

  meta = with lib; {
    description = "Easy and secure paper backups of secrets.";
    homepage = "https://github.com/matiaskorhonen/paper-age";
    license = licenses.mit;
    maintainers = [];
  };
}

