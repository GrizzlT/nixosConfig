{ pkgs, ... }:
{
  home.packages = with pkgs; [
    porsmo
    qrcp

    hledger
    hledger-web
    hledger-utils

    taskwarrior3
    timewarrior
    zk
  ];

  home.sessionVariables = {
    LEDGER_FILE = "$HOME/DATA/01_Administration/hledger/2024.journal";
  };
}
