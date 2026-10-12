{ fetchPypi, buildPythonPackage, poetry-core, setuptools, numpy, cython }:
buildPythonPackage rec {
  pname = "pyjls";
  version = "0.18.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "oMNjzElU1nMhU4TSLsGSJ8M4k/aIt5m9ssTKc9k1P3s=";
  };
  doCheck = false;
  format = "pyproject";

  propagatedBuildInputs = [ poetry-core setuptools numpy cython ];
}
