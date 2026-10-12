{ fetchFromGitHub, buildPythonPackage, uv-build, typing-extensions, pyyaml, aiohttp, aiologic, filelock }:
buildPythonPackage {
  pname = "ctf-attackapi";
  version = "0.3.0";
  # src = fetchPypi {
  #   inherit pname version;
  #   hash = "sha256-cx4NrbSWog6IZKpES7Hszd8iir0evuAagKSzBYvvQKM=";
  # };
  src = fetchFromGitHub {
    owner = "Attacking-Lab";
    repo = "ctf-attackapi";
    rev = "5d501e2148c5cf8baba20544eef0efe603886e51";
    hash = "sha256-OjcVUxGLtfjig0j+gzZ3BAOnQKsUi3Pg3o9MpKxvRsQ=";
  };
  doCheck = false;
  format = "pyproject";

  build-system = [ uv-build ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.9.27,<0.10.0' 'uv_build>=0.9.27'
  '';

  propagatedBuildInputs = [ typing-extensions pyyaml aiohttp filelock aiologic ];
}
