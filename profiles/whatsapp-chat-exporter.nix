{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "whatsapp-chat-exporter";
  version = "d0100ad";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "KnugiHK";
    repo = "Whatsapp-Chat-Exporter";
    rev = "d0100ad9043545194f9d3ab44a10ebf5fc74099a";
    hash = "sha256-U4HYE742CiODfz1GtxuW8nQduCeAzQgXYR0sWEwWuQc=";
  };

  propagatedBuildInputs = with python3Packages; [
    bleach
    jinja2
    pycryptodome
    javaobj-py3
    iphone-backup-decrypt
  ];

  meta = with lib; {
    homepage = "https://github.com/KnugiHK/Whatsapp-Chat-Exporter";
    description = "WhatsApp database parser";
    changelog = "https://github.com/KnugiHK/Whatsapp-Chat-Exporter/releases/tag/${version}";
    longDescription = ''
      A customizable Android and iPhone WhatsApp database parser that will give
      you the history of your WhatsApp conversations inHTML and JSON. Android
      Backup Crypt12, Crypt14 and Crypt15 supported.
    '';
    license = licenses.mit;
    mainProgram = "wtsexporter";
    maintainers = with maintainers; [ bbenno ];
  };
}
