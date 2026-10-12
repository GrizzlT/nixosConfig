{ fetchPypi, buildPythonPackage, hatchling, hatch-vcs, typing-extensions, sniffio, wrapt }:
buildPythonPackage rec {
  pname = "aiologic";
  version = "0.17.1";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LhuTueiM7TGMKmOtezgmiPQMv+QOPUIljUncnFrqF50=";
  };
  # src = fetchFromGitHub {
  #   owner = "Attacking-Lab";
  #   repo = "ctf-attackapi";
  #   rev = "5d501e2148c5cf8baba20544eef0efe603886e51";
  #   hash = "sha256-OjcVUxGLtfjig0j+gzZ3BAOnQKsUi3Pg3o9MpKxvRsQ=";
  # };
  doCheck = false;
  format = "pyproject";

  build-system = [ hatchling ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "python_version<'3.13'" "python_version<'3.14'"
  '';

  propagatedBuildInputs = [ typing-extensions sniffio wrapt hatch-vcs ];
}

