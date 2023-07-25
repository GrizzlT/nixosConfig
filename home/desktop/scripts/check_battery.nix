{ writeShellApplication, }:
writeShellApplication {
  name = "check_battery";
  runtimeInputs = [];
  text = ''
    COLOR=$(hyprpicker)
    echo ''${COLOR} | wl-copy -n
    notify-send "Color Picker" ''${COLOR}
  '';
}
