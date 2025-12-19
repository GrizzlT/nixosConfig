{ fetchFromGitHub, python3, twine }:
python3.pkgs.buildPythonApplication rec {
  pname = "emoji-fzf";
  version = "0.10.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "noahp";
    repo = "emoji-fzf";
    rev = version;
    hash = "sha256-W1lCzV+RjhjjbD2sHPQayGB7iu9eIcvy7EPrxFkORv4=";
    fetchSubmodules = true;
  };

  buildInputs = [ twine ];
  propagatedBuildInputs = with python3.pkgs; [ setuptools click ];
}
