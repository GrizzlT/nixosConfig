{ ... }:
{
  programs.foot = {
    enable = true;
    settings = {
      scrollback.multiplier = "15.0";
      key-bindings = {
        primary-paste = "none";
        search-start = "none";
        font-increase = "none";
        font-decrease = "none";
        font-reset = "none";
        spawn-terminal = "none";
        show-urls-launch = "none";
        prompt-prev = "none";
        prompt-next = "none";
        unicode-input = "none";
      };
    };
  };
}
