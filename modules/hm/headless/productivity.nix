{ pkgs, selfPkgs, ... }:
{
  home.packages = with pkgs; [
    selfPkgs.porsmo
    qrcp

    hledger
    hledger-web
    hledger-utils
  ];

  home.sessionVariables = { LEDGER_FILE = "$HOME/DATA/01_Administration/hledger/2024.journal"; };
}
