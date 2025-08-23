{ pkgs, ... }:
{
  services.udev = {
    packages = [ pkgs.qmk-udev-rules pkgs.stlink pkgs.qFlipper pkgs.android-udev-rules ];
    extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="0003", TAG+="uaccess", MODE="660", GROUP="wheel"
      SUBSYSTEM=="block", ENV{ID_VENDOR_ID}=="2e8a", ENV{ID_MODEL_ID}=="0003", GROUP="wheel", MODE="0660"
    '';
  };
}
