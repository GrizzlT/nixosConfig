{ pkgs, ... }:
{
  home.packages = with pkgs; [
    porsmo
    qrcp

    hledger
    hledger-web
    hledger-utils

    taskwarrior3
    zk
  ];

  home.sessionVariables = {
    LEDGER_FILE = "$HOME/DATA/01_Administration/hledger/2024.journal";
    ZK_NOTEBOOK_DIR = "$HOME/DATA/02_Informational/Zettelkasten/Notebook";
  };
}
