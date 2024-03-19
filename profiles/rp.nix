{
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation rec {
  name = "rp++";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "0vercl0k";
    repo = "rp";
    rev = "v" + version;
    sha256 = "+jpBgv8lue5rASR5vC6gCtHdeLSwzB/RXwSJxPjfPko=";
  };
  patches = [ ./0001-Add-install-directive-to-CmakeLists.patch ];
  sourceRoot = "source/src";

  nativeBuildInputs = [ cmake ];
}
