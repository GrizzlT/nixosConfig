{ fetchPypi, buildPythonPackage, setuptools, setuptools-scm, numpy, scipy, matplotlib, lib }:
buildPythonPackage rec {
  pname = "control";
  version = "0.10.1";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-O7oULJJ02Jbv2oyaIar2HdONZz1tQHFKeYnRQ0KOc4w=";
  };
  doCheck = false;
  format = "pyproject";

  propagatedBuildInputs = [ setuptools setuptools-scm numpy scipy matplotlib ];
}

