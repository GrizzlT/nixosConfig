{ fetchFromGitHub, buildPythonPackage, pycryptodome, fastpbkdf2, biplist, setuptools, lib }:
buildPythonPackage rec {
  pname = "iphone_backup_decrypt";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "KnugiHK";
    repo = "iphone_backup_decrypt";
    rev = "190d61c849045aded1863aa4bd1466e4d265f53d";
    hash = "sha256-z5qr59G2uHW43p6Cl8oBA7fSiDA4KLP5m2zmg+FH7I8=";
  };
  doCheck = false;
  format = "pyproject";

  propagatedBuildInputs = [ setuptools pycryptodome fastpbkdf2 biplist ];
}
