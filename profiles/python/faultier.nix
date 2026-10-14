{ fetchFromGitHub, buildPythonPackage, setuptools,
  pyserial,
  pyusb,
  plotly,
  google,
  protobuf,
  tqdm,
  matplotlib,
  jupyter,
  dash,
  pandas,
  dash-bootstrap-components,
  numpy,
}:
buildPythonPackage {
  pname = "faultier";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "hextreeio";
    repo = "faultier-python";
    rev = "9b2a16452b5901dd558b56ff637199d9bb068612";
    hash = "sha256-Cjlbeicg+s7sl8w4WtyCe891/LXh/oiQDfFtVYvV1vs=";
  };
  doCheck = false;
  format = "pyproject";

  build-system = [ setuptools ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'protobuf==5.29.5' 'protobuf>=5.29.5' \
      --replace-fail 'pyocd-faultier' 'numpy'
  '';

  propagatedBuildInputs = [ numpy pandas pyserial pyusb plotly google protobuf tqdm matplotlib jupyter dash pandas dash-bootstrap-components ];
}
