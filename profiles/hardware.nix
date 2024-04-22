{
  mkProfile,
  gnumake,
  tmux,
  minicom,
  usbutils,
  stlink-gui,
  blackmagic,
  orbuculum,
  pulseview,
  sigrok-cli,
  openocd,
  probe-rs,
  qFlipper,
}:

mkProfile {
  name = "hardware";
  paths = [
    gnumake
    tmux
    minicom
    usbutils
    stlink-gui
    blackmagic
    orbuculum
    pulseview
    sigrok-cli
    openocd
    probe-rs

    qFlipper
  ];
}
