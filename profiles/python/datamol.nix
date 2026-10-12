{ fetchPypi, buildPythonPackage, poetry-core, setuptools, setuptools-scm, numpy, cython, pandas, scipy, rdkit, matplotlib }:
buildPythonPackage rec {
  pname = "datamol";
  version = "0.12.5";
  src = fetchPypi {
    inherit pname version;
    sha256 = "jwxvSY1UKwyRgvaFukaGDwYorEwMqjsZWSMVBkG9zFc=";
  };
  doCheck = false;
  format = "pyproject";

  propagatedBuildInputs = [ poetry-core setuptools setuptools-scm numpy cython pandas scipy rdkit matplotlib];
}
