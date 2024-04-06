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
  ];
}
