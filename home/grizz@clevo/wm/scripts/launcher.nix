{ writeShellApplication, hyprland, foot, fzf, findutils, coreutils }:
writeShellApplication {
  name = "launcher";
  runtimeInputs = [ hyprland foot fzf findutils coreutils ];
  text = ''
    hyprctl dispatch 'hl.dsp.exec_cmd("foot --app-id=my-fzf-menu -- bash ${
      writeShellApplication {
        name = "inner-launcher";
        runtimeInputs = [ fzf findutils coreutils ];
        text = ''
          OPTS=("--info=inline" "--print-query" "--bind=ctrl-space:print-query,tab:replace-query")
          cmd=$(compgen -c | fzf "''${OPTS[@]}" | tail -1)
          hyprctl dispatch "hl.dsp.exec_cmd(\"$cmd\")"
        '';
      }
    }/bin/inner-launcher")'
  '';
}
