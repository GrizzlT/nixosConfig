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
  picotool,
  elf2uf2-rs,
  mpremote,
  rshell,
  qFlipper,
  ngspice,
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
    elf2uf2-rs
    picotool
    mpremote

    qFlipper

    rshell
    ngspice
  ];
}
