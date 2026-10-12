{ fetchPypi, buildPythonPackage, uv-build, click, pydantic, typing-extensions, ctf-attackapi }:
buildPythonPackage rec {
  pname = "ecsc2026ad";
  version = "0.2.3";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4x4NrbSWog6IZKpES7Hszd8iir0evuAagKSzBYvvQKM=";
  };
  doCheck = false;
  format = "pyproject";

  build-system = [ uv-build ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.9.27,<0.10.0' 'uv_build>=0.9.27' \
      --replace-fail 'pydantic>=2.13.4' 'pydantic>=2.12.0'
  '';

  propagatedBuildInputs = [ click ctf-attackapi pydantic typing-extensions ];
}
