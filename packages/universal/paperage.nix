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

  cargoHash = "sha256-sTTU75uk1vPZeFdkwBLDcdnZOKe2yepoIxZlY+wDgdA=";

  meta = with lib; {
    description = "Easy and secure paper backups of secrets.";
    homepage = "https://github.com/matiaskorhonen/paper-age";
    license = licenses.mit;
    maintainers = [];
  };
}

