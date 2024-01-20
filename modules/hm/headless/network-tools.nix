{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dig
    speedtest-rs
    speedtest-cli
  ];
}
