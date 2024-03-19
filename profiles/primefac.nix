{ fetchPypi, pythonPackages }:
pythonPackages.buildPythonPackage rec {
  pname = "primefac";
  version = "2.0.12";
  src = fetchPypi {
    inherit pname version;
    sha256 = "B2FnaaEGqGC9/0nV0thKUmeyYgWjhSkCn5+L+Rbl3F8=";
  };
  doCheck = false;
  format = "pyproject";

  propagatedBuildInputs = [ pythonPackages.setuptools ];
}
