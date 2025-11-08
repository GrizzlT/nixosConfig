{ fetchPypi, buildPythonPackage, poetry-core, matplotlib, numpy, scipy, psutil }:
buildPythonPackage rec {
  pname = "spicelib";
  version = "1.4.7";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7rvfMo1MwWHjanE16pf2YW0sLq7FOsIZPib4LsPCO/4=";
  };
  doCheck = false;
  format = "pyproject";

  propagatedBuildInputs = [ poetry-core matplotlib numpy scipy psutil ];
}
