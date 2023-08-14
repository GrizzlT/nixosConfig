{ writeShellApplication, hyprland, foot, fzf, findutils, coreutils }:
writeShellApplication {
  name = "launcher";
  runtimeInputs = [ hyprland foot fzf findutils coreutils ];
  text = ''
    OPTS='--info=inline --print-query --bind=ctrl-space:print-query,tab:replace-query'
    hyprctl dispatch exec "foot --app-id=my-fzf-menu bash -c \"compgen -c | fzf $OPTS | tail -1 | xargs hyprctl dispatch exec\""
  '';
}
