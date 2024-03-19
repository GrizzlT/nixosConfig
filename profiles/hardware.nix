{
  mkProfile,
  gnumake,
  screen,
  minicom,
  usbutils,
  pulseview,
  stlink,
  stlink-gui,
  blackmagic,
  orbuculum,
  saleae-logic-2,
  segger-ozone,
  sigrok-cli,
}:

mkProfile {
  name = "hardware";
  paths = [
    gnumake
    screen
    minicom
    usbutils
    pulseview
    stlink
    stlink-gui
    blackmagic
    orbuculum
    saleae-logic-2
    segger-ozone
    sigrok-cli
  ];
}
