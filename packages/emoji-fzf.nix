{ fetchFromGitHub, lib, python3, twine }:
python3.pkgs.buildPythonApplication rec {
  pname = "emoji-fzf";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "noahp";
    repo = "emoji-fzf";
    rev = version;
    sha256 = "KpJW91kGMvUe10kThCdtb/XZ+NCZoNDTsoDdCddSIao=";
    fetchSubmodules = true;
  };

  buildInputs = [ twine ];
  propagatedBuildInputs = with python3.pkgs; [ click ];
}
