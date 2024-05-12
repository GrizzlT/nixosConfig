{ fetchPypi, pythonPackages }:
pythonPackages.buildPythonPackage rec {
  pname = "padding_oracle";
  version = "0.4.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "172ff1ad292d9a9bb779bbc0c24c8c0607e028bd4fa3e8d6b7fead5983dcf6e8";
  };
  doCheck = false;
  format = "pyproject";

  propagatedBuildInputs = [ pythonPackages.setuptools pythonPackages.hatchling ];
}
