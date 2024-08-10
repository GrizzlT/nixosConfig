{ ... }:
{
  # Authority kit
  security.rtkit.enable = true;
  # Pipewire settings
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  programs.noisetorch.enable = true;
}
