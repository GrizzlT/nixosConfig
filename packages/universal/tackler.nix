{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "tackler";
  version = "v25.10.1";

  src = fetchFromGitHub {
    owner = "tackler-ng";
    repo = pname;
    rev = version;
    sha256= "il64qCTvaYX5+3qvkPCTYIsuFuFhS7TfCe9LcNo3v0c=";
  };

  cargoHash = "sha256-Xpbrm9JfavhcC/kAhChJiaWaKDeUpWk0/vt6zzUHo6g=";

  doCheck = false;

  meta = with lib; {
    description = "Fast, reliable bookkeeping engine with native GIT SCM support for plain text accounting";
    homepage = "https://github.com/tackler-ng/tackler";
    license = licenses.asl20;
    maintainers = [];
  };
}

