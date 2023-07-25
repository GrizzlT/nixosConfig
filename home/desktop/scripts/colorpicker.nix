{ writeShellApplication, hyprpicker, wl-clipboard, libnotify }:
writeShellApplication {
  name = "colorpicker";
  runtimeInputs = [ hyprpicker wl-clipboard libnotify ];
  text = ''
    COLOR=$(hyprpicker)
    echo ''${COLOR} | wl-copy -n
    notify-send "Color Picker" "''${COLOR}"
  '';
}
