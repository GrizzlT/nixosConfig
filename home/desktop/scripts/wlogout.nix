{ writeShellApplication, wlogout }:
writeShellApplication {
  name = "wlogout";
  runtimeInputs = [ wlogout ];
  text = ''
    if [[ ! $(pidof wlogout) ]]; then
      wlogout --buttons-per-row 5 \
        --column-spacing 50 \
        --row-spacing 50 \
        --margin-top 390 \
        --margin-bottom 390 \
        --margin-left 150 \
        --margin-right 150
    else
      pkill wlogout
    fi
  '';
}
