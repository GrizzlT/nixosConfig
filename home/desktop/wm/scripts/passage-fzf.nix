{ writeShellApplication, writeScriptBin, hyprland, foot, fzf, findutils, gnused, coreutils, ydotool, jq }:
let
  runtimeInputs = [  hyprland foot fzf findutils gnused coreutils ydotool jq ];
  promptScript = writeShellApplication {
    name = "fzf-passage-prompt";
    inherit runtimeInputs;
    text = ''
    select_passwd() {
      PREFIX="''${PASSAGE_DIR:-$HOME/.passage/store}"
      export FZF_DEFAULT_OPTS=""
      name="$(find "$PREFIX" -type f -name '*.age' | \
          sed -e "s|$PREFIX/||" -e 's|\.age$||' | \
          fzf --height 40% --reverse --no-multi)"
      pass=$(passage "$name" | head -n 1)
      hyprctl dispatch focuswindow "address:$1"
      ydotool type "''${pass}"
    }

    export YDOTOOL_SOCKET=/tmp/ydotools
    nohup ydotoold --socket-path /tmp/ydotools &>/dev/null &
    select_passwd "$1"
    pkill ydotool
    '';
  };
in
writeShellApplication {
  name = "passage-fzf-type";
  inherit runtimeInputs;
  text = ''
    window=$(hyprctl activewindow -j | jq -r '.address')
    hyprctl dispatch exec "foot --app-id=my-fzf-menu ${promptScript}/bin/fzf-passage-prompt ''${window}"
  '';
}
