{ ... }:
{
  programs.broot = {
    enable = true;
    settings.verbs = [
      {
        invocation = "lazygit";
        shortcut = "gg";
        apply_to = "directory";
        external = "lazygit";
        set_working_dir = true;
        leave_broot = false;
      }
    ];
  };
}
