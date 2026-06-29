{ pkgs, ... }:
{
  home.packages = with pkgs; [
    porsmo
    qrcp

    hledger
    hledger-web
    hledger-utils

    monero-cli

    tackler

    taskwarrior3
    timewarrior
    zk
    cfait

    just
  ];

  home.sessionVariables = {
    LEDGER_FILE = "$HOME/DATA/01_Administration/Finances/hledger/current.journal";
  };
}
