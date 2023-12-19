{ ... }:
{
  programs.broot = {
    enable = true;
    enableZshIntegration = true;
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
