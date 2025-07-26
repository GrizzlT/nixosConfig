{ pkgs, ... }:
{
  services.udev.packages = [ pkgs.qmk-udev-rules pkgs.stlink pkgs.qFlipper pkgs.android-udev-rules pkgs.saleae-logic-2 ];
}
