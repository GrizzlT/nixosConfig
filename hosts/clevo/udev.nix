{ pkgs, ... }:
{
  services.udev.packages = [ pkgs.qmk-udev-rules pkgs.stlink ];
}
