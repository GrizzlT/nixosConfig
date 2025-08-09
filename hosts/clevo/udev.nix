{ pkgs, ... }:
{
  services.udev = {
    packages = [ pkgs.qmk-udev-rules pkgs.stlink pkgs.qFlipper pkgs.android-udev-rules ];
    extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="0003", TAG+="uaccess"
    '';
  };
}
