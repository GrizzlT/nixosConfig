{ ... }:
{
  services.xserver = {
    enable = true;
    autorun = false;
    displayManager.startx.enable = true;
    windowManager.i3.enable = true;
  };
  services.libinput.mouse.naturalScrolling = true;
}
